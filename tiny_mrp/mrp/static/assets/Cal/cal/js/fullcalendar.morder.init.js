document.addEventListener('DOMContentLoaded', function () {
  var Calendar = FullCalendar.Calendar;
  var Draggable = FullCalendar.Draggable;

  var containerEl = document.getElementById('external-events');
  var containerE2 = document.getElementById('external-events2');
  var calendarEl = document.getElementById('calendar');
  var checkbox = document.getElementById('drop-remove');
  var lineSelector = document.querySelector('select[name="line_selector"]');

  var pendingDropInfo = null;
  var editingEvent = null;
  var orderColors = {};
  var selectedLineId = lineSelector ? lineSelector.value : null;

  if (lineSelector) {
    lineSelector.addEventListener('change', function() {
      selectedLineId = this.value;
      calendar.refetchEvents();
    });
  }

  function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  }

  new Draggable(containerEl, {
    itemSelector: '.fc-event',
  });
  
  new Draggable(containerE2, {
    itemSelector: '.fc-event',
    eventData: function (eventEl) {
      return {
        title: eventEl.innerText
      }
    }
  });

  function updateOrderInSidebar(orderId, originalTitle, quantity, action) {
    var unassignedContainer = document.getElementById('unassignedOrdersContainer');
    var assignedContainer = document.getElementById('assignedOrdersContainer');
    
    var existingOrderEl = null;
    if (unassignedContainer) {
      existingOrderEl = unassignedContainer.querySelector(`[data-id="${orderId}"]`);
    }
    if (!existingOrderEl && assignedContainer) {
      existingOrderEl = assignedContainer.querySelector(`[data-id="${orderId}"]`);
    }
    
    if (existingOrderEl) {
      var currentQty = parseFloat(existingOrderEl.getAttribute('data-quantity'));
      var newQty = action === 'increase' ? currentQty + quantity : currentQty - quantity;
      
      if (newQty > 0) {
        existingOrderEl.setAttribute('data-quantity', newQty);
        var quantityDivs = existingOrderEl.querySelectorAll('div');
        for (var i = 0; i < quantityDivs.length; i++) {
          if (quantityDivs[i].textContent.includes('باقیمانده:') || quantityDivs[i].textContent.includes('مقدار:')) {
            quantityDivs[i].innerHTML = `باقیمانده: <strong>${newQty.toFixed(0)} kg</strong>`;
            break;
          }
        }
      } else {
        var isUnassigned = existingOrderEl.getAttribute('data-has-assigned-line') === 'false';
        existingOrderEl.remove();
        
        if (isUnassigned) {
          var currentCount = parseInt($('#unassignedOrdersCount').text());
          $('#unassignedOrdersCount').text(Math.max(0, currentCount - 1));
        } else {
          var currentCount = parseInt($('#assignedOrdersCount').text());
          $('#assignedOrdersCount').text(Math.max(0, currentCount - 1));
        }
      }
    } else if (action === 'increase') {
      restoreOrderToSidebar(orderId, originalTitle, quantity);
    }
  }

  function restoreOrderToSidebar(orderId, originalTitle, quantity) {
    $.ajax({
      url: `/MOrder/order-details/${orderId}/`,
      type: 'GET',
      success: function(response) {
        if (response.success) {
          var order = response.order;
          var container = order.has_assigned_line ? 
                         $('#assignedOrdersContainer') : 
                         $('#unassignedOrdersContainer');
          
          var backgroundColor = order.has_assigned_line ? '#e7f1ff' : '#fff3cd';
          var textColor = order.has_assigned_line ? '#007bff' : '#856404';
          var borderColor = order.has_assigned_line ? 'transparent' : '#ffc107';
          
          var orderHtml = `
            <div class="list-group-item fc-event order-item" 
                 data-id="${order.id}" 
                 data-type="order" 
                 data-quantity="${quantity}"
                 data-line-id="${order.line_id || ''}"
                 data-has-assigned-line="${order.has_assigned_line}"
                 style="background-color: ${backgroundColor}; color: ${textColor}; cursor: move; border-left: 4px solid ${borderColor};">
              <div>
                <i class="fa fa-circle ${order.has_assigned_line ? 'text-success' : 'text-warning'}"></i> 
                <strong>${order.title}</strong>
              </div>
              <div class="small">
                محصول: ${order.product_name}
              </div>
              <div class="small">
                باقیمانده: <strong>${quantity.toFixed(0)} kg</strong>
              </div>
              ${order.has_assigned_line ? 
                `<div class="small text-muted">
                  <i class="fa fa-industry"></i> ${order.line_name}
                </div>
                <div class="small text-success">
                  <i class="fa fa-check-circle"></i> قابل استفاده در خطوط دیگر
                </div>` : 
                `<div class="small text-muted">
                  <i class="fa fa-info-circle"></i> قابل تخصیص به هر خطی
                </div>`
              }
            </div>
          `;
          
          container.append(orderHtml);
          
          if (order.has_assigned_line) {
            var currentCount = parseInt($('#assignedOrdersCount').text());
            $('#assignedOrdersCount').text(currentCount + 1);
          } else {
            var currentCount = parseInt($('#unassignedOrdersCount').text());
            $('#unassignedOrdersCount').text(currentCount + 1);
          }
          
          new Draggable(container[0], {
            itemSelector: '.fc-event',
          });
        }
      },
      error: function() {
        toastr.error('خطا در بارگذاری اطلاعات سفارش');
      }
    });
  }

  $('#dailyCapacity').on('input', function() {
    var totalQuantity = parseFloat($('#totalQuantity').val());
    var dailyCapacity = parseFloat($(this).val());
    
    if (dailyCapacity > 0) {
      var daysNeeded = Math.ceil(totalQuantity / dailyCapacity);
      $('#estimatedDays').val(daysNeeded + ' روز');
    } else {
      $('#estimatedDays').val('');
    }
  });

  $('#confirmCapacity').on('click', function() {
    var dailyCapacity = parseFloat($('#dailyCapacity').val());
    
    if (!selectedLineId) {
      alert('لطفا خط تولید را انتخاب کنید');
      return;
    }
    
    if (!dailyCapacity || dailyCapacity <= 0) {
      alert('لطفا ظرفیت روزانه معتبر وارد کنید');
      return;
    }

    if (editingEvent) {
      var deductFromRemaining = !$('#independentEdit').is(':checked');
      updateEventCapacity(editingEvent, dailyCapacity, deductFromRemaining);
    } else if (pendingDropInfo) {
      createEventsFromDrop(pendingDropInfo, dailyCapacity);
    }
    
    $('#dailyCapacityModal').modal('hide');
    pendingDropInfo = null;
    editingEvent = null;
    $('#dailyCapacityForm')[0].reset();
    $('#independentEditContainer').hide();
  });

  $('#dailyCapacityModal').on('hidden.bs.modal', function () {
    pendingDropInfo = null;
    editingEvent = null;
    $('#dailyCapacityForm')[0].reset();
    $('#independentEditContainer').hide();
    $('.order-info-alert').remove();
  });

  function updateEventCapacity(event, newCapacity, deductFromRemaining) {
    var oldQuantity = event.extendedProps.quantity;
    var difference = newCapacity - oldQuantity;
    var orderId = event.extendedProps.orderId;
    var originalTitle = event.extendedProps.originalTitle;
    
    event.setExtendedProp('quantity', newCapacity);
    event.setProp('title', `${originalTitle} - ${newCapacity}kg`);
    event.setExtendedProp('is_new', true);
    
    if (deductFromRemaining && difference > 0) {
      var relatedEvents = calendar.getEvents().filter(function (evt) {
        return evt.extendedProps.orderId === orderId && 
               evt.extendedProps.lineId === selectedLineId &&
               evt.id !== event.id;
      });
      
      relatedEvents.sort(function(a, b) {
        return new Date(a.start) - new Date(b.start);
      });
      
      var remainingDifference = difference;
      var removedEvents = 0;
      
      for (var i = 0; i < relatedEvents.length && remainingDifference > 0; i++) {
        var relatedEvent = relatedEvents[i];
        var currentQuantity = relatedEvent.extendedProps.quantity;
        
        if (currentQuantity > remainingDifference) {
          var newQty = currentQuantity - remainingDifference;
          relatedEvent.setExtendedProp('quantity', newQty);
          relatedEvent.setProp('title', `${originalTitle} - ${newQty}kg`);
          relatedEvent.setExtendedProp('is_new', true);
          remainingDifference = 0;
        } else {
          remainingDifference -= currentQuantity;
          relatedEvent.remove();
          removedEvents++;
        }
      }
      
      if (removedEvents > 0) {
        toastr.info(removedEvents + ' رویداد با ظرفیت صفر از تقویم حذف شد.');
      }
      
      if (remainingDifference > 0) {
        toastr.warning('ظرفیت کافی در سایر روزها وجود نداشت. مقدار ' + remainingDifference + 'kg باقی مانده است.');
      }
    } else if (deductFromRemaining && difference < 0) {
      var absDeficit = Math.abs(difference);
      updateOrderInSidebar(orderId, originalTitle, absDeficit, 'increase');
    }
    
    toastr.success('ظرفیت رویداد به‌روزرسانی شد');
  }

  function createEventsFromDrop(info, dailyCapacity) {
    var quantity = parseFloat(info.draggedEl.getAttribute('data-quantity'));
    var orderId = info.draggedEl.getAttribute('data-id');
    var titleElement = info.draggedEl.querySelector('strong');
    var title = titleElement ? titleElement.textContent.trim() : info.draggedEl.innerText.split('محصول:')[0].trim();
    var dropDate = info.date;

    if (!orderColors[orderId]) {
      orderColors[orderId] = getRandomColor();
    }
    var orderColor = orderColors[orderId];

    var daysNeeded = Math.ceil(quantity / dailyCapacity);
    var eventsToCreate = [];
    
    for (var i = 0; i < daysNeeded; i++) {
      var eventDate = new Date(dropDate);
      eventDate.setDate(dropDate.getDate() + i);
      
      var dayQuantity = (i < daysNeeded - 1) ? dailyCapacity : 
                       (quantity - (dailyCapacity * (daysNeeded - 1)));
      
      eventsToCreate.push({
        date: eventDate,
        quantity: dayQuantity,
        index: i,
        orderId: orderId,
        title: title
      });
    }
    
    checkMultipleDaysCapacity(eventsToCreate, 0, orderColor, function(approvedEvents) {
      var totalApproved = 0;
      approvedEvents.forEach(function(eventData) {
        calendar.addEvent({
          title: `${eventData.title} - ${eventData.quantity}kg`,
          start: eventData.date,
          backgroundColor: orderColor,
          borderColor: orderColor,
          textColor: '#ffffff',
          id: `temp-${orderId}-${Date.now()}-${eventData.index}`,
          extendedProps: {
            quantity: eventData.quantity,
            orderId: orderId,
            lineId: selectedLineId,
            type: 'order',
            originalTitle: eventData.title,
            originalQuantity: quantity,
            is_new: true
          },
        });
        totalApproved += eventData.quantity;
      });
      
      if (checkbox.checked && approvedEvents.length > 0) {
        info.draggedEl.parentNode.removeChild(info.draggedEl);
      }
      
      var totalRejected = quantity - totalApproved;
      
      if (approvedEvents.length < eventsToCreate.length) {
        toastr.warning(`${approvedEvents.length} روز از ${eventsToCreate.length} روز ایجاد شد. ${totalRejected.toFixed(0)}kg به دلیل کمبود ظرفیت ایجاد نشد.`);
      } else {
        toastr.success(`${approvedEvents.length} رویداد با موفقیت ایجاد شد (${totalApproved.toFixed(0)}kg)`);
      }
    });
  }
  
  // تابع بررسی ظرفیت با محاسبه رویدادهای موقت
  function checkMultipleDaysCapacity(events, index, orderColor, callback) {
    if (index >= events.length) {
      callback(events);
      return;
    }
    
    var event = events[index];
    var dateStr = event.date.toISOString().split('T')[0];
    
    // محاسبه ظرفیت استفاده شده از رویدادهای موقت (is_new=true)
    var tempEventsOnDate = calendar.getEvents().filter(function(evt) {
      var evtDateStr = evt.start.toISOString().split('T')[0];
      return evtDateStr === dateStr && 
             evt.extendedProps.lineId === selectedLineId &&
             evt.extendedProps.type === 'order' &&
             evt.extendedProps.is_new === true;
    });
    
    var tempUsedCapacity = 0;
    tempEventsOnDate.forEach(function(evt) {
      tempUsedCapacity += evt.extendedProps.quantity || 0;
    });
    
    $.ajax({
      url: `/MOrder/line-capacity/${selectedLineId}/${dateStr}/`,
      type: 'GET',
      success: function(response) {
        if (response.success) {
          // ظرفیت واقعی استفاده شده از دیتابیس + ظرفیت موقت
          var totalUsedCapacity = response.used_capacity + tempUsedCapacity;
          var actualAvailableCapacity = response.total_capacity - totalUsedCapacity;
          
          console.log(`تاریخ ${dateStr}: ظرفیت کل=${response.total_capacity}, DB=${response.used_capacity}, موقت=${tempUsedCapacity}, باقیمانده=${actualAvailableCapacity}, نیاز=${event.quantity}`);
          
          if (event.quantity > actualAvailableCapacity) {
            // اگر ظرفیت کافی نیست، اما مقداری باقی مانده
            if (actualAvailableCapacity > 0) {
              var userChoice = confirm(
                `ظرفیت کامل در تاریخ ${dateStr} وجود ندارد.\n\n` +
                `ظرفیت کل: ${response.total_capacity}kg\n` +
                `استفاده شده (ذخیره شده): ${response.used_capacity}kg\n` +
                `استفاده شده (موقت): ${tempUsedCapacity.toFixed(0)}kg\n` +
                `باقیمانده: ${actualAvailableCapacity.toFixed(0)}kg\n` +
                `مورد نیاز: ${event.quantity}kg\n` +
                `کسری: ${(event.quantity - actualAvailableCapacity).toFixed(0)}kg\n\n` +
                `آیا می‌خواهید ${actualAvailableCapacity.toFixed(0)}kg را برای این روز اختصاص دهید؟`
              );
              
              if (userChoice) {
                event.quantity = actualAvailableCapacity;
                checkMultipleDaysCapacity(events, index + 1, orderColor, callback);
              } else {
                // حذف این روز و ادامه
                events.splice(index, 1);
                checkMultipleDaysCapacity(events, index, orderColor, callback);
              }
            } else {
              // ظرفیت صفر است
              var userChoice = confirm(
                `ظرفیت در تاریخ ${dateStr} تکمیل است.\n\n` +
                `ظرفیت کل: ${response.total_capacity}kg\n` +
                `استفاده شده (ذخیره شده): ${response.used_capacity}kg\n` +
                `استفاده شده (موقت): ${tempUsedCapacity.toFixed(0)}kg\n` +
                `باقیمانده: 0kg\n` +
                `مورد نیاز: ${event.quantity}kg\n\n` +
                `آیا می‌خواهید این روز را رد کنید و ادامه دهید؟`
              );
              
              if (userChoice) {
                events.splice(index, 1);
                checkMultipleDaysCapacity(events, index, orderColor, callback);
              } else {
                callback([]);
              }
            }
          } else {
            // ظرفیت کافی است
            checkMultipleDaysCapacity(events, index + 1, orderColor, callback);
          }
        } else {
          toastr.error('خطا در بررسی ظرفیت');
          callback([]);
        }
      },
      error: function() {
        toastr.error('خطا در ارتباط با سرور');
        callback([]);
      }
    });
  }

  var trashEl = document.getElementById('trash');

  var calendar = new Calendar(calendarEl, {
    headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,timeGridDay',
    },
    
    businessHours: true,
    editable: true,
    locale: 'fa',
    
    eventDidMount: function(info) {
      if (info.event.backgroundColor) {
        info.el.style.backgroundColor = info.event.backgroundColor;
        info.el.style.borderColor = info.event.backgroundColor;
      }
      
      if (info.event.extendedProps.lineName) {
        info.el.title = `خط: ${info.event.extendedProps.lineName}\nمقدار: ${info.event.extendedProps.quantity}kg`;
      }
    },
    
    events: function(fetchInfo, successCallback, failureCallback) {
      if (!selectedLineId) {
        successCallback([]);
        return;
      }
      
      $.ajax({
        url: '/MOrder/Calendar/GetInfo/',
        type: 'GET',
        data: { line_id: selectedLineId },
        success: function(events) {
          events.forEach(function(event) {
            if (event.extendedProps && event.extendedProps.orderId) {
              if (!orderColors[event.extendedProps.orderId]) {
                orderColors[event.extendedProps.orderId] = event.backgroundColor || getRandomColor();
              }
            }
          });
          successCallback(events);
        },
        error: function() {
          toastr.error('خطا در دریافت رویدادها');
          failureCallback();
        }
      });
    },

    eventClick: function(info) {
      var event = info.event;
      
      if (event.extendedProps.type === 'order') {
        editingEvent = event;
        
        var originalTitle = event.extendedProps.originalTitle || event.title.split(' - ')[0];
        var currentQuantity = event.extendedProps.quantity || 0;
        
        $('#orderTitle').val(originalTitle);
        $('#totalQuantity').val(currentQuantity);
        $('#dailyCapacity').val(currentQuantity);
        $('#estimatedDays').val('1 روز');
        $('#independentEdit').prop('checked', false);
        $('#independentEditContainer').show();
        $('#dailyCapacityModal .modal-title').text('ویرایش ظرفیت تولید روزانه');
        $('#dailyCapacityModal').modal('show');
      } else {
        alert('نوع رویداد: ' + event.extendedProps.type + '\nعنوان: ' + event.title);
      }
    },

    drop: function(info) {
      var eventType = info.draggedEl.getAttribute('data-type');
      
      if (eventType === 'order') {
          var quantity = parseFloat(info.draggedEl.getAttribute('data-quantity'));
          var titleElement = info.draggedEl.querySelector('strong');
          var title = titleElement ? titleElement.textContent.trim() : info.draggedEl.innerText.split('محصول:')[0].trim();
          var orderLineId = info.draggedEl.getAttribute('data-line-id');
          var hasAssignedLine = info.draggedEl.getAttribute('data-has-assigned-line') === 'true';
          
          if (!selectedLineId) {
              alert('لطفا ابتدا خط تولید را انتخاب کنید');
              return;
          }
          
          // اجازه دادن به استفاده از سفارشات در خطوط مختلف
          if (hasAssignedLine && orderLineId && selectedLineId != orderLineId) {
              var lineNameEl = info.draggedEl.querySelector('.small.text-muted');
              var lineName = lineNameEl ? lineNameEl.textContent.replace('خط:', '').trim() : 'خط دیگر';
              
              // نمایش پیام تأیید با اطلاعات بیشتر
              var confirmMessage = 
                  `این سفارش به "${lineName}" تخصیص داده شده است.\n\n` +
                  `مقدار باقیمانده: ${quantity} kg\n` +
                  `آیا می‌خواهید بخشی از آن را در خط فعلی نیز برنامه‌ریزی کنید؟\n\n` +
                  `توجه: این کار باعث کاهش مقدار باقیمانده سفارش می‌شود.`;
              
              if (!confirm(confirmMessage)) {
                  return;
              }
          }
          
          pendingDropInfo = info;
          
          $('#orderTitle').val(title);
          $('#totalQuantity').val(quantity);
          $('#dailyCapacity').val('');
          $('#estimatedDays').val('');
          $('#independentEditContainer').hide();
          
          // نمایش اطلاعات اضافی برای سفارشات خطوط دیگر
          if (hasAssignedLine && orderLineId && selectedLineId != orderLineId) {
              // حذف آلرت‌های قبلی
              $('.order-info-alert').remove();
              
              $('#orderTitle').after(
                  '<div class="alert alert-info mt-2 order-info-alert">' +
                  '<i class="fa fa-info-circle"></i> ' +
                  'این سفارش در خط دیگری نیز برنامه‌ریزی شده است. ' +
                  'مقدار باقیمانده: ' + quantity + ' kg. ' +
                  'می‌توانید بخشی از آن را در این خط نیز برنامه‌ریزی کنید.' +
                  '</div>'
              );
          }
          
          $('#dailyCapacityModal .modal-title').text('تعیین ظرفیت تولید روزانه');
          $('#dailyCapacityModal').modal('show');
      } else {
          // کد قبلی برای سایر انواع رویدادها
          var title = info.draggedEl.innerText;
          
          calendar.addEvent({
              title: title,
              start: info.date,
              backgroundColor: info.draggedEl.style.backgroundColor,
              extendedProps: {
                  type: eventType,
                  lineId: selectedLineId,
                  is_new: true
              }
          });
  
          if (checkbox.checked) {
              info.draggedEl.parentNode.removeChild(info.draggedEl);
          }
      }
  },

    eventDragStop: function (info) {
      var trashRect = trashEl.getBoundingClientRect();
      var x = info.jsEvent.clientX;
      var y = info.jsEvent.clientY;

      if (x >= trashRect.left && x <= trashRect.right && 
          y >= trashRect.top && y <= trashRect.bottom) {
        if (confirm('آیا مطمئن هستید که می‌خواهید این رویداد را حذف کنید?')) {
          var event = info.event;
          var orderId = event.extendedProps.orderId;
          var deletedQuantity = event.extendedProps.quantity;
          var originalTitle = event.extendedProps.originalTitle;
          
          info.event.remove();
          
          if (orderId && deletedQuantity > 0 && event.extendedProps.type === 'order') {
            updateOrderInSidebar(orderId, originalTitle, deletedQuantity, 'increase');
            toastr.success(`${deletedQuantity}kg به سفارش بازگردانده شد`);
          }
          
          updateLineCapacityDisplay();
        }
      }
    },

    eventDrop: function(info) {
      console.log('Event moved:', info.event);
      info.event.setExtendedProp('is_new', true);
      updateLineCapacityDisplay();
    }
  });

  calendar.render();

  function updateLineCapacityDisplay() {
    if (selectedLineId) {
      var today = new Date().toISOString().split('T')[0];
      
      $.ajax({
        url: `/MOrder/line-capacity/${selectedLineId}/${today}/`,
        type: 'GET',
        success: function(response) {
          if (response.success) {
            var percentage = response.usage_percentage.toFixed(1);
            $('#capacityBar').css('width', percentage + '%');
            $('#capacityText').text(
              response.used_capacity + ' / ' + response.total_capacity + ' kg (' + percentage + '%)'
            );
            
            if (percentage < 50) {
              $('#capacityBar').css('background', '#28a745');
            } else if (percentage < 80) {
              $('#capacityBar').css('background', '#ffc107');
            } else {
              $('#capacityBar').css('background', '#dc3545');
            }
          }
        }
      });
    }
  }

// در بخش save_event فایل fullcalendar.morder.init.js
$('.save_event').on('click', function (e) {
  if (!selectedLineId) {
      alert('لطفا خط تولید را انتخاب کنید');
      return;
  }
  
  // فقط رویدادهای جدید را فیلتر کنید
  var allEvents = calendar.getEvents().filter(function (evt) {
      return evt.extendedProps.is_new === true;
  });
  
  if (allEvents.length === 0) {
      alert('هیچ رویداد جدیدی در تقویم وجود ندارد.');
      return;
  }
  
  var eventDetails = allEvents.map(function (evt) {
      return {
          title: evt.title,
          start: evt.start ? evt.start.toISOString().split('T')[0] : 'N/A',
          quantity: evt.extendedProps.quantity || 0,
          orderId: evt.extendedProps.orderId || null,
          type: evt.extendedProps.type || 'order',
          description: evt.extendedProps.description || '',
          tempId: evt.id // اضافه کردن tempId برای ردیابی
      };
  });

  $.ajax({
      url: '/MOrder/bulk-create-events/',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ 
          events: eventDetails,
          line_id: selectedLineId
      }),
      success: function (response) {
          if (response.success) {
              // حذف رویدادهای موقت از تقویم
              allEvents.forEach(function (evt) {
                  evt.remove();
              });
              
              toastr.success(response.message || 'رویدادها با موفقیت ذخیره شدند.');
              
              if (response.errors && response.errors.length > 0) {
                  response.errors.forEach(function(error) {
                      toastr.warning(error.error);
                  });
              }
              
              // اضافه کردن رویدادهای ذخیره شده به تقویم
              if (response.events && response.events.length > 0) {
                  response.events.forEach(function(savedEvent) {
                      calendar.addEvent({
                          id: savedEvent.id,
                          title: savedEvent.title,
                          start: savedEvent.start,
                          backgroundColor: savedEvent.backgroundColor,
                          borderColor: savedEvent.borderColor,
                          textColor: savedEvent.textColor,
                          extendedProps: savedEvent.extendedProps
                      });
                      
                      // به‌روزرسانی موجودی سفارش در سایدبار
                      if (savedEvent.extendedProps && savedEvent.extendedProps.orderId) {
                          var orderId = savedEvent.extendedProps.orderId;
                          var quantity = savedEvent.extendedProps.quantity;
                          var originalTitle = savedEvent.extendedProps.originalTitle;
                          updateOrderInSidebar(orderId, originalTitle, quantity, 'decrease');
                      }
                  });
              }
              
              updateLineCapacityDisplay();
          } else {
              toastr.error('خطا در ذخیره رویدادها: ' + (response.error || 'خطای ناشناخته'));
          }
      },
      error: function (xhr) {
          toastr.error('خطا در ارتباط با سرور: ' + (xhr.responseJSON?.error || 'خطایی ناشناخته'));
      }
  });
});
});