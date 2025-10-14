document.addEventListener('DOMContentLoaded', function () {
  var Calendar = FullCalendar.Calendar;
  var Draggable = FullCalendar.Draggable;

  var containerEl = document.getElementById('external-events');
  var containerE2 = document.getElementById('external-events2');
  var calendarEl = document.getElementById('calendar');
  var checkbox = document.getElementById('drop-remove');

  // متغیرهای موقت برای ذخیره اطلاعات
  var pendingDropInfo = null;
  var editingEvent = null;

  // ذخیره رنگ‌های سفارشات
  var orderColors = {};

  // تابع تولید رنگ تصادفی
  function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  }

  // initialize the external events
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

  // محاسبه تعداد روزهای مورد نیاز بر اساس ظرفیت روزانه
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

  // تایید و ایجاد رویدادها (برای drop جدید)
  $('#confirmCapacity').on('click', function() {
    var dailyCapacity = parseFloat($('#dailyCapacity').val());
    
    if (!dailyCapacity || dailyCapacity <= 0) {
      alert('لطفا ظرفیت روزانه معتبر وارد کنید');
      return;
    }

    if (editingEvent) {
      // ویرایش رویداد موجود
      var deductFromRemaining = !$('#independentEdit').is(':checked');
      updateEventCapacity(editingEvent, dailyCapacity, deductFromRemaining);
    } else if (pendingDropInfo) {
      // ایجاد رویدادهای جدید
      createEventsFromDrop(pendingDropInfo, dailyCapacity);
    }
    
    $('#dailyCapacityModal').modal('hide');
    pendingDropInfo = null;
    editingEvent = null;
    $('#dailyCapacityForm')[0].reset();
    $('#independentEditContainer').hide();
  });

  // بستن مودال و پاک کردن اطلاعات
  $('#dailyCapacityModal').on('hidden.bs.modal', function () {
    pendingDropInfo = null;
    editingEvent = null;
    $('#dailyCapacityForm')[0].reset();
    $('#independentEditContainer').hide();
  });

  // تابع ویرایش ظرفیت رویداد
  function updateEventCapacity(event, newCapacity, deductFromRemaining) {
    var oldQuantity = event.extendedProps.quantity;
    var difference = newCapacity - oldQuantity;
    var orderId = event.extendedProps.orderId;
    var originalTitle = event.extendedProps.originalTitle;
    var orderColor = event.backgroundColor;
    
    // به‌روزرسانی مقدار رویداد فعلی
    event.setExtendedProp('quantity', newCapacity);
    event.setProp('title', `${originalTitle} - ${newCapacity}kg`);
    event.setExtendedProp('is_new', true);
    
    if (deductFromRemaining && difference > 0) {
      // کسر کردن از سایر رویدادهای همین سفارش
      var relatedEvents = calendar.getEvents().filter(function (evt) {
        return evt.extendedProps.orderId === orderId && evt.id !== event.id;
      });
      
      // مرتب کردن رویدادها بر اساس تاریخ (از جدید به قدیم یا بالعکس)
      relatedEvents.sort(function(a, b) {
        return new Date(a.start) - new Date(b.start);
      });
      
      var remainingDifference = difference;
      var removedEvents = 0;
      
      // کسر کردن به صورت متوالی از رویدادهای بعدی
      for (var i = 0; i < relatedEvents.length && remainingDifference > 0; i++) {
        var relatedEvent = relatedEvents[i];
        var currentQuantity = relatedEvent.extendedProps.quantity;
        
        if (currentQuantity > remainingDifference) {
          // این رویداد کافیه برای کسر کردن
          var newQty = currentQuantity - remainingDifference;
          relatedEvent.setExtendedProp('quantity', newQty);
          relatedEvent.setProp('title', `${originalTitle} - ${newQty}kg`);
          relatedEvent.setExtendedProp('is_new', true);
          remainingDifference = 0;
        } else {
          // این رویداد رو کامل حذف میکنیم (ظرفیت صفر یا کمتر شده)
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
      // کاهش ظرفیت - به سفارشات بازگردانده میشه
      var absDeficit = Math.abs(difference);
      updateOrderInSidebar(orderId, originalTitle, absDeficit, 'increase');
    }
    
    toastr.success('ظرفیت رویداد به‌روزرسانی شد');
  }

  // تابع به‌روزرسانی سفارش در سایدبار
  function updateOrderInSidebar(orderId, originalTitle, quantity, action) {
    var ordersContainer = document.getElementById('external-events');
    var existingOrderEl = ordersContainer.querySelector(`[data-id="${orderId}"]`);
    
    if (existingOrderEl) {
      var currentQty = parseFloat(existingOrderEl.getAttribute('data-quantity'));
      var newQty = action === 'increase' ? currentQty + quantity : currentQty - quantity;
      
      if (newQty > 0) {
        existingOrderEl.setAttribute('data-quantity', newQty);
        existingOrderEl.innerHTML = `<i class="fa fa-circle text-success" data-icon="car"></i> ${originalTitle} - ${newQty}kg`;
      } else {
        existingOrderEl.remove();
      }
    } else if (action === 'increase' && quantity > 0) {
      // ایجاد آیتم جدید در سایدبار
      var newOrderEl = document.createElement('div');
      newOrderEl.className = 'list-group-item fc-event';
      newOrderEl.setAttribute('data-id', orderId);
      newOrderEl.setAttribute('data-type', 'order');
      newOrderEl.setAttribute('data-quantity', quantity);
      newOrderEl.style.backgroundColor = '#e7f1ff';
      newOrderEl.style.color = '#007bff';
      newOrderEl.innerHTML = `<i class="fa fa-circle text-success" data-icon="car"></i> ${originalTitle} - ${quantity}kg`;

      var ordersHeader = ordersContainer.querySelector('h6');
      if (ordersHeader) {
        ordersHeader.insertAdjacentElement('afterend', newOrderEl);
      } else {
        ordersContainer.appendChild(newOrderEl);
      }
    }
  }

  // تابع ایجاد رویدادها
  function createEventsFromDrop(info, dailyCapacity) {
    var quantity = parseFloat(info.draggedEl.getAttribute('data-quantity'));
    var orderId = info.draggedEl.getAttribute('data-id');
    var title = info.draggedEl.innerText.split(' - ')[0];
    var dropDate = info.date;

    // اگر این سفارش رنگ نداره، یه رنگ تصادفی بهش بده
    if (!orderColors[orderId]) {
      orderColors[orderId] = getRandomColor();
    }
    var orderColor = orderColors[orderId];

    var daysNeeded = Math.ceil(quantity / dailyCapacity);
    
    for (var i = 0; i < daysNeeded; i++) {
        var eventDate = new Date(dropDate);
        eventDate.setDate(dropDate.getDate() + i);
        
        var dayQuantity = (i < daysNeeded - 1) ? dailyCapacity : 
                         (quantity - (dailyCapacity * (daysNeeded - 1)));
        
        calendar.addEvent({
            title: `${title} - ${dayQuantity}kg`,
            start: eventDate,
            backgroundColor: orderColor,
            borderColor: orderColor,
            textColor: '#ffffff',
            id: `${orderId}-${Date.now()}-${i}`,
            extendedProps: {
                quantity: dayQuantity,
                orderId: orderId,
                type: 'order',
                originalTitle: title,
                originalQuantity: quantity,
                is_new: true
            },
        });
    }

    if (checkbox.checked) {
        info.draggedEl.parentNode.removeChild(info.draggedEl);
    }
  }

  var trashEl = document.getElementById('trash');

  // initialize the calendar
  var calendar = new Calendar(calendarEl, {
      headerToolbar: {
          left: 'prev,next today addEventButton',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay',
      },
      
      businessHours: true,
      editable: true,
      locale: 'fa',
      eventDidMount: function(info) {
        // اطمینان از اینکه رنگ پس‌زمینه صحیح اعمال شده
        if (info.event.backgroundColor) {
          info.el.style.backgroundColor = info.event.backgroundColor;
          info.el.style.borderColor = info.event.backgroundColor;
        }
      },
      events: {
        url: '/MOrder/Calendar/GetInfo/',
        method: 'GET',
        failure: function() {
          alert('خطا در دریافت رویدادها!');
        },
        success: function(events) {
          // ذخیره رنگ‌های رویدادهای موجود
          events.forEach(function(event) {
            if (event.extendedProps && event.extendedProps.orderId) {
              if (!orderColors[event.extendedProps.orderId]) {
                orderColors[event.extendedProps.orderId] = event.backgroundColor || getRandomColor();
              }
            }
          });
        }
      },

      customButtons: {
          addEventButton: {
              text: 'افزودن رویداد',
              click: function () {
                  var dateStr = prompt('تاریخ را وارد کنید YYYY-MM-DD فرمت');
                  var date = new Date(dateStr + 'T00:00:00');

                  if (!isNaN(date.valueOf())) {
                      calendar.addEvent({
                          title: 'dynamic event',
                          start: date,
                          allDay: true
                      });
                      alert('عالی. در حال حاضر، پایگاه داده خود را به روز کنید...');
                  } else {
                      alert('تاریخ نامعتبر.');
                  }
              }
          }
      },
      
      editable: true,
      droppable: true,

      // کلیک روی رویداد برای ویرایش
      eventClick: function(info) {
        var event = info.event;
        
        // فقط برای رویدادهای نوع order
        if (event.extendedProps.type === 'order') {
          editingEvent = event;
          
          var originalTitle = event.extendedProps.originalTitle || event.title.split(' - ')[0];
          var currentQuantity = event.extendedProps.quantity || 0;
          
          // پر کردن فرم مودال
          $('#orderTitle').val(originalTitle);
          $('#totalQuantity').val(currentQuantity);
          $('#dailyCapacity').val(currentQuantity);
          $('#estimatedDays').val('1 روز');
          $('#independentEdit').prop('checked', false);
          
          // نمایش تیک "ویرایش مستقل"
          $('#independentEditContainer').show();
          
          // تغییر عنوان مودال
          $('#dailyCapacityModal .modal-title').text('ویرایش ظرفیت تولید روزانه');
          
          // نمایش مودال
          $('#dailyCapacityModal').modal('show');
        } else {
          // برای رویدادهای دیگر، اطلاعات را نمایش بده
          alert('نوع رویداد: ' + event.extendedProps.type + '\nعنوان: ' + event.title);
        }
      },

      drop: function(info) {
        var eventType = info.draggedEl.getAttribute('data-type');
        
        // اگر نوع رویداد Order باشد، مودال را نمایش بده
        if (eventType === 'order') {
          var quantity = parseFloat(info.draggedEl.getAttribute('data-quantity'));
          var title = info.draggedEl.innerText.split(' - ')[0];
          
          // ذخیره اطلاعات drop
          pendingDropInfo = info;
          
          // پر کردن فرم مودال
          $('#orderTitle').val(title);
          $('#totalQuantity').val(quantity);
          $('#dailyCapacity').val('');
          $('#estimatedDays').val('');
          
          // مخفی کردن تیک "ویرایش مستقل"
          $('#independentEditContainer').hide();
          
          // بازگشت عنوان مودال به حالت اولیه
          $('#dailyCapacityModal .modal-title').text('تعیین ظرفیت تولید روزانه');
          
          // نمایش مودال
          $('#dailyCapacityModal').modal('show');
          
        } else {
          // برای رویدادهای دیگر (تعطیلات و ...) مستقیم اضافه کن
          var title = info.draggedEl.innerText;
          
          calendar.addEvent({
              title: title,
              start: info.date,
              backgroundColor: info.draggedEl.style.backgroundColor,
              extendedProps: {
                  type: eventType,
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
                var originalQuantity = event.extendedProps.originalQuantity;
                
                info.event.remove();
                console.log('Event removed:', info.event.id);
                
                var remainingQuantity = 0;
                var total_val = 0;
                var relatedEvents = calendar.getEvents().filter(function (evt) {
                    return evt.extendedProps.orderId === orderId;
                });

                relatedEvents.forEach(function (evt) {
                    remainingQuantity += evt.extendedProps.quantity;
                });

                if (relatedEvents.length === 0) {
                    remainingQuantity = originalQuantity;
                    total_val = originalQuantity;
                } else {
                    total_val = originalQuantity - remainingQuantity;
                }
                
                if (total_val > 0 && event.extendedProps.type === 'order') {
                    updateOrderInSidebar(orderId, originalTitle, total_val, 'increase');
                }
            }
        }
      },

      eventDrop: function(info) {
        console.log('Event moved:', info.event);
        // علامت‌گذاری به عنوان تغییر یافته
        info.event.setExtendedProp('is_new', true);
      }
  });

  calendar.render();

  // ذخیره رویدادها
  $('.save_event').on('click', function (e) {
    var allEvents = calendar.getEvents().filter(function (evt) {
      return evt.extendedProps.is_new === true;
    });
    
    if (allEvents.length === 0) {
      alert('هیچ رویداد جدیدی در تقویم وجود ندارد.');
      return;
    }
    
    var eventDetails = allEvents.map(function (evt) {
      return {
        id: evt.extendedProps.orderId,
        title: evt.title,
        start: evt.start ? evt.start.toISOString().split('T')[0] : 'N/A',
        quantity: evt.extendedProps.quantity || 0,
        orderId: evt.extendedProps.orderId || null,
        type: evt.extendedProps.type || 'unknown',
        backgroundColor: evt.backgroundColor
      };
    });

    $.ajax({
      url: '/MOrder/bulk-create-events/',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ events: eventDetails }),
      success: function (response) {
        if (response.success) {
          allEvents.forEach(function (evt) {
            evt.remove();
          });
          response.events.forEach(function (savedEvent) {
            calendar.addEvent({
              id: savedEvent.id,
              title: savedEvent.title,
              start: savedEvent.start,
              backgroundColor: savedEvent.backgroundColor,
              borderColor: savedEvent.backgroundColor,
              textColor: '#ffffff',
              extendedProps: {
                quantity: savedEvent.extendedProps.quantity,
                orderId: savedEvent.extendedProps.orderId,
                originalTitle: savedEvent.extendedProps.originalTitle,
                originalQuantity: savedEvent.extendedProps.originalQuantity,
                type: savedEvent.extendedProps.type,
                is_new: false
              }
            });
          });
          toastr.success('رویدادها با موفقیت ذخیره شدند.');
        } else {
          toastr.error('خطا در ذخیره رویدادها: ' + response.error);
        }
      },
      error: function (xhr) {
        alert('خطا در ارتباط با سرور: ' + (xhr.responseJSON?.error || 'خطایی ناشناخته'));
      }
    });
  });
});