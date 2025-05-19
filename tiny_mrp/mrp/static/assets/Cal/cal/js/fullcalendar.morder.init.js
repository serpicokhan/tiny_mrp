document.addEventListener('DOMContentLoaded', function () {
  var Calendar = FullCalendar.Calendar;
  var Draggable = FullCalendar.Draggable;

  var containerEl = document.getElementById('external-events');
  var calendarEl = document.getElementById('calendar');
  var checkbox = document.getElementById('drop-remove');


  // initialize the external events
  // -----------------------------------------------------------------

  new Draggable(containerEl, {
      itemSelector: '.fc-event',
    //   eventData: function (eventEl) {
    //       return {
    //           title: ''
    //       };
    //   }
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
                color: '#53c797',

                
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
    eventDrop: function(info) {
        // Handle event drag within calendar
        console.log('Event moved:', info.event);
        
        // Here you can add logic to update other related events if needed
        // For example, if this is part of a multi-day order
    }
});

calendar.render();
});