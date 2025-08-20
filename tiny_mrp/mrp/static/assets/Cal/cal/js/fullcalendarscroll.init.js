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
    function formatDateToYYYYMMDD(date) {
        const year = date.getFullYear(); // Gets the year (4 digits)
        
        // Gets the month (0-11). Adding 1 to make it 1-12, and padStart to ensure two digits
        const month = (date.getMonth() + 1).toString().padStart(2, '0');
        
        // Gets the day of the month (1-31), padStart to ensure two digits
        const day = date.getDate().toString().padStart(2, '0');
        
        // Concatenate in YYYY-MM-DD format
        return `${year}-${month}-${day}`;
      }
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
         url: `/Tolid/GetInfo?makan=${$("#makan_select").val()}`, // Replace with your server-side script to fetch events
         method: 'GET',
         failure: function() {
           // Handle failure to fetch events
           alert('There was an error while fetching events!');
         }
       },
       eventDrop:function(info){
        if(info.event.backgroundColor!="red"){
            // Open a new window when an event is clicked
            confirm_it=confirm("اطلاعات به تاریخ جدید کپی شود؟");
            if(confirm_it){
                console.log(info.oldEvent.start,info.event.start);
                console.log(new Date(info.event.start).toLocaleDateString());
                $.ajax({
                    url: '/Tolid/Move/', // Your endpoint to update the event
                    type: 'POST',
                    data: {
                      id: info.event.id,
                      start: formatDateToYYYYMMDD(new Date(info.oldEvent.start)),
                      end: info.event.start ? formatDateToYYYYMMDD(new Date(info.event.start)) : null,
                    },
                    success: function(response) {
                        if(response.success=="success")
                            console.log('Event updated successfully');    
                        else{
                            TransformStream.error("انتقال ناموفق بود");
                        }
                    },
                    error: function() {
                      console.log('Error updating event');
                      info.revert(); // Revert the event to its original position in case of error
                    }
                  });
                }
            else{
                info.revert();
            }
          }
          else{
            window.open('/Tolid/DailyZayeat?event_id=' + info.event.id, '_blank');
          }
        
       },
       eventClick: function(info) {
         if(info.event.backgroundColor!="red"){
     // Open a new window when an event is clicked
     window.open(`/Tolid/DailyDetails/Scroll?event_id=${info.event.id}&makan_id=${$("#makan_select").val()}`, '_blank');
   }
   else{
     window.open(`/Tolid/DailyZayeat?event_id=${info.event.id}&makan_id=${$("#makan_select").val()}`, '_blank');
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
