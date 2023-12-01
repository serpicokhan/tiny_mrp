'use strict';
$(document).ready(function () {

    $('input[name="single-date-picker"]').daterangepicker({
        singleDatePicker: true,
        showDropdowns: true,

        "locale": {
            "format": 'DD-MM-YYYY',
            "separator": " - ",
            "applyLabel": "ثبت",
            "cancelLabel": "لغو",
            "customRangeLabel": "بازه دلخواه",
            "daysOfWeek": [
                "ی", "د", "س", "چ", "پ", "ج", "ش"
            ],
            "monthNames": [
                "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"
            ],
            "firstDay": 1
        }
    });

    $('.simple-date-range-picker').daterangepicker({
        buttonClasses: ['btn', 'btn-sm'],
        applyClass: 'btn-danger',
        cancelClass: 'btn-inverse',

        "locale": {
            "format": 'DD-MM-YYYY',
            "separator": " - ",
            "applyLabel": "ثبت",
            "cancelLabel": "لغو",
            "customRangeLabel": "بازه دلخواه",
            "daysOfWeek": [
                "ی", "د", "س", "چ", "پ", "ج", "ش"
            ],
            "monthNames": [
                "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"
            ],
            "firstDay": 1
        }
    });



    $('input[name="simple-date-range-picker-callback"]').daterangepicker({
        opens: 'left',
        "locale": {
            "format": 'DD-MM-YYYY',
            "separator": " - ",
            "applyLabel": "ثبت",
            "cancelLabel": "لغو",
            "customRangeLabel": "بازه دلخواه",
            "daysOfWeek": [
                "ی", "د", "س", "چ", "پ", "ج", "ش"
            ],
            "monthNames": [
                "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"
            ],
            "firstDay": 1
        }
    }, function (start, end, label) {


        swal("تاریخ مورد نظر شما اعمال شد", start.format('YYYY-MM-DD') + ' تا ' + end.format('YYYY-MM-DD'), "success")
    });





    $('input[name="datetimes"]').daterangepicker({
        timePicker: true,
        "locale": {
            "format": 'DD-MM-YYYY HH:mm',
            "separator": " - ",
            "applyLabel": "ثبت",
            "cancelLabel": "لغو",
            "customRangeLabel": "بازه دلخواه",
            "daysOfWeek": [
                "ی", "د", "س", "چ", "پ", "ج", "ش"
            ],
            "monthNames": [
                "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"
            ],
            "firstDay": 1
        },

    });




    /**
     * datefilter
     */



    var datefilter = $('input[name="datefilter"]');
    datefilter.daterangepicker({
        autoUpdateInput: false,
        "locale": {
            // "format": 'DD-MM-YYYY',
            "separator": " - ",
            "applyLabel": "ثبت",
            "cancelLabel": "لغو",
            "customRangeLabel": "بازه دلخواه",
            "daysOfWeek": [
                "ی", "د", "س", "چ", "پ", "ج", "ش"
            ],
            "monthNames": [
                "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"
            ],
            "firstDay": 1,
            "cancelLabel": "Clear"
        },

    });

    datefilter.on('apply.daterangepicker', function (ev, picker) {
        $(this).val(picker.startDate.format('DD-MM-YYYY') + ' - ' + picker.endDate.format('DD-MM-YYYY'));
    });

    $('input.create-event-datepicker').daterangepicker({
        singleDatePicker: true,
        showDropdowns: true,
        autoUpdateInput: false
    }).on('apply.daterangepicker', function (ev, picker) {
        $(this).val(picker.startDate.format('DD-MM-YYYY'));
    });
    document.getElementById("hidden").value = "ورودی خالی"
});
