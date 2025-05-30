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
      events: [
  
      ],

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
                    orderId: orderId
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
                info.event.remove(); // Remove the event from the calendar
                console.log('Event removed:', info.event.id);
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
});