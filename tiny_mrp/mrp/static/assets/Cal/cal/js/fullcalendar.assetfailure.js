var events2=[];
document.addEventListener('DOMContentLoaded', function () {
    var Calendar = FullCalendar.Calendar;
    var Draggable = FullCalendar.Draggable;

    // var containerEl = document.getElementById('external-events');
    var calendarEl = document.getElementById('calendar');
    // var checkbox = document.getElementById('drop-remove');


    // initialize the external events
    // -----------------------------------------------------------------

    // new Draggable(containerEl, {
    //     itemSelector: '.fc-event',
    //     eventData: function (eventEl) {
    //         return {
    //             title: eventEl.innerText
    //         };
    //     }
    // });

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
         url: '/AssetFailure/Daily/GetInfo', // Replace with your server-side script to fetch events
         method: 'GET',
         failure: function() {
           // Handle failure to fetch events
           alert('There was an error while fetching events!');
         }
       },
       eventClick: function(info) {
     // Open a new window when an event is clicked
     window.open('/AssetFailure?date=' + info.event.id, '_blank');
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
        eventTextColor: 'white',
        droppable: true, // this allows things to be dropped onto the calendar
        drop: function (info) {
            // is the "remove after drop" checkbox checked?
            if (checkbox.checked) {
                // if so, remove the element from the "Draggable Events" list
                info.draggedEl.parentNode.removeChild(info.draggedEl);
            }
        }
    });

      // read_calendar_data();
      calendar.render();



});
