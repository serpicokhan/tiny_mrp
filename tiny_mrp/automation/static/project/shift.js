
$(function () {


    var loadForm =function (btn1) {
      var btn=0;
      if($(btn1).attr("type")=="click")
       btn=$(this);
      else {
        btn=btn1;
      }

      return $.ajax({
        url: btn.attr("data-url"),
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


  // // Update book
  $("#company-table").on("click", ".js-update-shift", myWoLoader);
  $("#modal-company").on("submit", ".js-shift-update-form", saveForm);

  });
