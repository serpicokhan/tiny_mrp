
$(function () {


    var loadForm =function (btn1) {
      var btn=0;
      if($(btn1).attr("type")=="click")
       btn=$(this);
      else {
        btn=btn1;
      }

      return $.ajax({
        url: btn.attr("data-url")+`?dt=${$("#search").val()}`,
        type: 'get',
        dataType: 'json',
        beforeSend: function () {
          $("#modal-company").modal("show");
        },
        success: function (data) {

          $("#modal-company .modal-content").html(data.html_failure_form);
          
         
       

        }
      });



  };
     function numberToWords(num) {
    const units = ["", "هزار", "میلیون", "میلیارد", "تریلیون"];
    const ones = ["", "یک", "دو", "سه", "چهار", "پنج", "شش", "هفت", "هشت", "نه"];
    const teens = ["ده", "یازده", "دوازده", "سیزده", "چهارده", "پانزده", "شانزده", "هفده", "هجده", "نوزده"];
    const tens = ["", "ده", "بیست", "سی", "چهل", "پنجاه", "شصت", "هفتاد", "هشتاد", "نود"];
    const hundreds = ["", "صد", "دویست", "سیصد", "چهارصد", "پانصد", "ششصد", "هفتصد", "هشتصد", "نهصد"];

    // if (num === 0) return "صفر";

    let words = "";

    for (let i = 0; num > 0; i++) {
        const part = num % 1000;
        if (part !== 0) {
            let partWords = "";
            if (part < 10) {
                partWords = ones[part];
            } else if (part < 20) {
                partWords = teens[part - 10];
            } else if (part < 100) {
                partWords = tens[Math.floor(part / 10)] + " " + ones[part % 10];
            } else {
                partWords = hundreds[Math.floor(part / 100)] + " " + numberToWords(part % 100);
            }
            words = partWords + " " + units[i] + " " + words;
        }
        num = Math.floor(num / 1000);
    }

    return words.trim();
}
$("#modal-company").on('input','#id_price_personnel', function() {
  // دریافت مقدار فعلی فیلد
  const value = $(this).val();
  // نمایش مقدار در پاراگراف
  $('#id_price').text(numberToWords(value));
  console.log(123);
  
});
  var saveForm= function () {
     var form = $(this);


     $.ajax({
       url: form.attr("action"),
       data: form.serialize(),
       type: form.attr("method"),
       dataType: 'json',
       success: function (data) {

         if (data.form_is_valid) {
           $("#tbody_company").empty();
           $("#tbody_company").html(data.html_failure_list);
           $("#modal-company").modal("hide");
         }
         else {

           toastr.error(data.error);
         }
       }
     });
     return false;
   };


   var myWoLoader= function(){
     btn=$(this);
     console.log(1);



     loadForm(btn);

   }


   var redirect_to_tolid_padash=function(){
  
    window.location=`/Asset/Randeman/V2/NezafatPadash/?profile=${$("#profile_year").val()}`;
  }
  $("#go_to_profile").click(function(){
    redirect_to_tolid_padash();
  });
//   $('#modal-company').on('blur','#id_price_sarshift', function() {
//     var input = $(this).val();
//     var number = input.replace(/[^\d]/g, ''); // Strip non-numeric characters

//     if (number) { // Check if number is not empty
//         var formattedNumber = parseInt(number, 10).toLocaleString(); // Format number with commas
//         $(this).val(formattedNumber); // Update the input with the formatted number
//         // $("#id_price_sarshift").val(1);
//     }

    
// });


  // $(".js-create-assetFailure").click(myWoLoader);
  // $("#modal-company").on("submit", ".js-assetFailure-create-form", saveForm);

  // // Update book
  $("#company-table").on("click", ".js-update-tolidPadash", myWoLoader);
  $("#modal-company").on("submit", ".js-tolidPadash-update-form", saveForm);
  // $("#modal-company").on("submit", ".js-AssetFailure-delete-form", saveForm);

  // // Delete book js-assetFailure-delete
  // // $("#company-table").on("click", ".js-delete-assetFailure", loadForm);
  // $("#company-table").on("click", ".js-assetFailure-delete", myWoLoader);
  
  });
