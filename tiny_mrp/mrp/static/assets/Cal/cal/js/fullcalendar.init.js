document.addEventListener('DOMContentLoaded', function () {
    var Calendar = FullCalendar.Calendar;
    var Draggable = FullCalendar.Draggable;

    var containerEl = document.getElementById('external-events');
    var calendarEl = document.getElementById('calendar');
    var checkbox = document.getElementById('drop-remove');
    var events=[];

    // initialize the external events
    // -----------------------------------------------------------------

    new Draggable(containerEl, {
        itemSelector: '.fc-event',
        eventData: function (eventEl) {
            return {
                title: eventEl.innerText
            };
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
    {
        "title": "آمار روزانه",
        "start": "2023-12-05",

        "id": "2023-12-05"
    },
    {
        "title": "آمار روزانه",
        "start": "2023-12-04",
      
        "id": "2023-12-04"
    }
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
        drop: function (info) {
            // is the "remove after drop" checkbox checked?
            if (checkbox.checked) {
                // if so, remove the element from the "Draggable Events" list
                info.draggedEl.parentNode.removeChild(info.draggedEl);
            }
        }
    });
    var read_calendar_data=function(){
          // $.ajax({
          //     url
          // });
          // console.log($('.input-daterange-datepicker').val());
          // const date_range=$('.input-daterange-datepicker').val();
          $.ajax({
              url:'/Tolid/GetInfo',
              method:'get',
              success:function(doc){
                  var events=[];
                  console.log(doc);
                  if (doc != null) {
                      var i=null;
                  for(i in doc){
                      // console.log(i);
                      if(doc[i].start){
                          var dt=new Date(doc[i].start);
                    events.push({



                      title: 'ملاقات',
                      start: dt,
                      constraint: 'availableForMeeting', // defined below
                      color: '#53c797'

                      // end: doc.to_date
                    });
                  }
                  }
              }
                  // var a2=[data.i];





              }
          });

      }

      read_calendar_data();
      console.log(events);
      calendar.render();
});
