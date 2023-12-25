
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
            console.log(data);
          $("#modal-company .modal-content").html(data.html_assetFailure_form);
          $('.clockpicker-example').clockpicker({
            donetext: 'Done',
            autoclose: true
        });
  
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
           $("#tbody_company").html(data.html_assetFailure_list);
           $("#modal-company").modal("hide");
         }
         else {
  
           $("#company-table tbody").html(data.html_assetFailure_list);
           $("#modal-company .modal-content").html(data.html_assetFailure_form);
         }
       }
     });
     return false;
   };
  
  
   var myWoLoader= function(){
     btn=$(this);
  
  
  
     loadForm(btn);
  
   }
  
  
   $('#search').pDatepicker({
    format: 'YYYY-MM-DD',
    autoClose: true,
    initialValueType: 'gregorian'
  });
  $(".js-create-assetFailure").click(myWoLoader);
  $("#modal-company").on("submit", ".js-assetFailure-create-form", saveForm);
  
  // Update book
  $("#company-table").on("click", ".js-update-assetFailure", myWoLoader);
  $("#modal-company").on("submit", ".js-assetFailure-update-form", saveForm);
  // Delete book
  $("#company-table").on("click", ".js-delete-assetFailure", loadForm);
  $("#modal-company").on("submit", ".js-assetFailure-delete-form", saveForm);
  });
  