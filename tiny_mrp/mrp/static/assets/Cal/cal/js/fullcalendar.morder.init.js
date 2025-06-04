document.addEventListener('DOMContentLoaded', function () {
  var Calendar = FullCalendar.Calendar;
  var Draggable = FullCalendar.Draggable;

  var containerEl = document.getElementById('external-events');
  var containerE2 = document.getElementById('external-events2');

  var calendarEl = document.getElementById('calendar');
  var checkbox = document.getElementById('drop-remove');


  // initialize the external events
  // -----------------------------------------------------------------

  new Draggable(containerEl, {
      itemSelector: '.fc-event',
    //   eventData: function (eventEl) {
       
    //     // if(eventEl.attr("data-type") != "order")
    //     console.log(eventEl.getAttribute('data-type'));
    //     if(eventEl.getAttribute('data-type')!="order"){
       
        
    //       return {
    //         title: eventEl.innerText
    //     }
    //   }
    // }
        
      
  });
  new Draggable(containerE2, {
    itemSelector: '.fc-event',
    eventData: function (eventEl) {
     
      // if(eventEl.attr("data-type") != "order")
      return {
        title: eventEl.innerText
    }
  }
      
    
});
var trashEl = document.getElementById('trash');
new Draggable(trashEl, {
    itemSelector: null, // No specific item selector needed for the drop target
    drop: function (info) {
        // Get the dropped event's ID
        var eventId = info.draggedEl.getAttribute('data-id');
        var event = calendar.getEventById(eventId);

        if (event) {
            // Optionally prompt for confirmation
            if (confirm('Are you sure you want to delete this event?')) {
                event.remove(); // Remove the event from the calendar
                console.log('Event removed:', eventId);
            }
        }
    }
});

  // initialize the calendar
  // -----------------------------------------------------------------

  var calendar = new Calendar(calendarEl, {
      headerToolbar: {
          left: 'prev,next today addEventButton',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay',
          
      },
      
      businessHours: true, // display business hours
      editable: true,
      locale: 'fa',
      events: {
        url: '/MOrder/Calendar/GetInfo/', // Replace with your server-side script to fetch events
        method: 'GET',
        failure: function() {
          // Handle failure to fetch events
          alert('There was an error while fetching events!');
        }
      },

      customButtons: {
          addEventButton: {
              text: 'افزودن رویداد',
              click: function () {
                  var dateStr = prompt('تاریخ را وارد کنید YYYY-MM-فرمتmat');
                  var date = new Date(dateStr + 'T00:00:00'); // will be in local time

                  if (!isNaN(date.valueOf())) { // valid?
                      calendar.addEvent({
                          title: 'dynamic event',
                          start: date,
                          allDay: true
                      });
                      alert('عالی.در حال حاضر، پایگاه داده خود را به روز کنید...');
                  } else {
                      alert('تاریخ نامعتبر.');
                  }
              }
          }
      },
      
      editable: true,
      droppable: true, // this allows things to be dropped onto the calendar


    drop: function(info) {
        // Get the dropped element's data
        
        
        var quantity = parseFloat(info.draggedEl.getAttribute('data-quantity'));
        var orderId = info.draggedEl.getAttribute('data-id');
        var title = info.draggedEl.innerText;
        var dropDate = info.date; // Date where the event was dropped

        // Calculate days needed (ceiling division)
        var daysNeeded = Math.ceil(quantity / dailyLimit);
        
        // Generate events for each day
        for (var i = 0; i < daysNeeded; i++) {
            var eventDate = new Date(dropDate);
            eventDate.setDate(dropDate.getDate() + i); // Add i days
            
            // Calculate quantity for this day
            var dayQuantity = (i < daysNeeded - 1) ? dailyLimit : 
                             (quantity - (dailyLimit * (daysNeeded - 1)));
            
            calendar.addEvent({
                title: `${title} - ${dayQuantity}kg`,
                start: eventDate,
                backgroundColor: 'red',

                
                id: `${orderId}-${i}`,
                extendedProps: {
                    quantity: dayQuantity,
                    orderId: orderId,
                    type:'order',
                    originalTitle:title,
                    originalQuantity:quantity,
                    is_new:true

                },
            });
        }

        // Remove the dragged element if checkbox is checked
        if (checkbox.checked) {
            info.draggedEl.parentNode.removeChild(info.draggedEl);
        }
    },
    eventDragStop: function (info) {
        // Get the mouse position and trash element position
        var trashEl = document.getElementById('trash');
        var trashRect = trashEl.getBoundingClientRect();
        var x = info.jsEvent.clientX;
        var y = info.jsEvent.clientY;

        // Check if the event was dropped over the trash area
        if (
            x >= trashRect.left &&
            x <= trashRect.right &&
            y >= trashRect.top &&
            y <= trashRect.bottom
        ) {
            if (confirm('Are you sure you want to delete this event?')) {
                var event = info.event;
                var orderId = event.extendedProps.orderId;
                var deletedQuantity = event.extendedProps.quantity;
                var originalTitle = event.extendedProps.originalTitle;
                var originalQuantity = event.extendedProps.originalQuantity;
                info.event.remove(); // Remove the event from the calendar
                console.log('Event removed:', info.event.id);
                // Calculate remaining quantity for the order
                var remainingQuantity = 0;
                var total_val=0;
                var relatedEvents = calendar.getEvents().filter(function (evt) {
                    return evt.extendedProps.orderId === orderId;
                });

                // Sum the quantities of remaining events
                relatedEvents.forEach(function (evt) {
                    console.log(evt.extendedProps.quantity);
                    
                    remainingQuantity += evt.extendedProps.quantity;
                });
                
                

                // If there are no remaining events, use the original quantity minus deleted quantity
                if (relatedEvents.length === 0) {
                    remainingQuantity = originalQuantity ;
                    total_val=originalQuantity;
                }
                else
                {
                 total_val=originalQuantity-remainingQuantity;

                    // remainingQuantity=(originalQuantity-remainingQuantity)-deletedQuantity;
                }
                
                
                if (remainingQuantity > 0 && event.extendedProps.type === 'order') {
                    var ordersContainer = document.getElementById('external-events');
                    // console.log(remainingQuantity);
                      // Check if an order with this orderId already exists
                    var existingOrderEl = ordersContainer.querySelector(`[data-id="${orderId}"]`);
                    if (existingOrderEl) {
                    // Update existing order's quantity
                    existingOrderEl.setAttribute('data-quantity', remainingQuantity);
                    existingOrderEl.innerHTML = `<i class="fa fa-circle text-success" data-icon="car"></i> ${originalTitle} - ${total_val}kg`;
                    } else {
                    // Create new order element
                    var newOrderEl = document.createElement('div');
                    newOrderEl.className = 'list-group-item fc-event';
                    newOrderEl.setAttribute('data-id', orderId);
                    newOrderEl.setAttribute('data-type', 'order');
                    newOrderEl.setAttribute('data-quantity', total_val);
                    newOrderEl.style.backgroundColor = '#e7f1ff';
                    newOrderEl.style.color = '#007bff';
                    newOrderEl.innerHTML = `<i class="fa fa-circle text-success" data-icon="car"></i> ${originalTitle} - ${total_val}kg`;

                    // Append to the Orders section (after the "سفارشات" header)
                    var ordersHeader = ordersContainer.querySelector('h6');
                    if (ordersHeader) {
                        ordersHeader.insertAdjacentElement('afterend', newOrderEl);
                    } else {
                        ordersContainer.appendChild(newOrderEl);
                    }
                    }
                }
                


            }
        }
    },
    eventDrop: function(info) {
        // Handle event drag within calendar
        console.log('Event moved:', info.event);
        
        // Here you can add logic to update other related events if needed
        // For example, if this is part of a multi-day order
    }
});

calendar.render();
$('.save_event').on('click', function (e) {
    // e.preventDefault(); // Prevent default form submission
    
    // Access the calendar instance (assumes 'calendar' is globally defined in fullcalendar.morder.init.js)
    // var calendar = $('#calendar').fullCalendar('getCalendar');
    var allEvents = calendar.getEvents().filter(function (evt) {
    return evt.extendedProps.is_new === true; // Filter unsaved events
    });
    
   
    
    if (allEvents.length === 0) {
    alert('هیچ رویداد جدیدی در تقویم وجود ندارد.');
    return;
    }
    
    // Optional: Display event details for debugging
    var eventDetails = allEvents.map(function (evt) {
    return {
        id: evt.extendedProps.orderId,
        title: evt.title,
        start: evt.start ? evt.start.toISOString().split('T')[0] : 'N/A',
        quantity: evt.extendedProps.quantity || 0,
        orderId: evt.extendedProps.orderId || null,
        type: evt.extendedProps.type || 'unknown'
    };
    });
    $.ajax({
        url: '/MOrder/bulk-create-events/',
        type: 'POST',
        // headers: {
        //   'X-CSRFToken': getCookie('csrftoken') // Include CSRF token
        // },
        contentType: 'application/json',
        data: JSON.stringify({ events: eventDetails }),
        success: function (response) {
          if (response.success) {
            // Update calendar with saved events
            allEvents.forEach(function (evt) {
              evt.remove(); // Remove unsaved event
            });
            response.events.forEach(function (savedEvent) {
              calendar.addEvent({
                id: savedEvent.id,
                title: savedEvent.title,
                start: savedEvent.start,
                backgroundColor: savedEvent.backgroundColor,
                extendedProps: {
                  quantity: savedEvent.extendedProps.quantity,
                  orderId: savedEvent.extendedProps.orderId,
                  originalTitle: savedEvent.extendedProps.originalTitle,
                  originalQuantity: savedEvent.extendedProps.originalQuantity,
                  type: savedEvent.extendedProps.type,
                  is_new: false // Mark as saved
                }
              });
            });
            $('#createEventModal').modal('hide');
            $('#create-event-form')[0].reset();
            toastr.success('رویدادها با موفقیت ذخیره شدند.');
          } else {
            toastr.error('خطا در ذخیره رویدادها: ' + response.error);
          }
        },
        error: function (xhr) {
          alert('خطا در ارتباط با سرور: ' + (xhr.responseJSON?.error || 'خطای ناشناخته'));
        }
      });
    
    
    
   
});
});
