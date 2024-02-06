
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

          $("#modal-company .modal-content").html(data.html_assetFailure_form);
          $('.clockpicker-example').clockpicker({
            donetext: 'Done',
            autoclose: true
        });

        }
      });



  };
  $("#button-addon1").click(function(){
    window.location=`AssetFailure?fdate=${$("#search").val()}`;
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
  var delete_asset_failure=function(){
     swal({
         title: "مطمئن هستید؟",
         text: "",
         icon: "warning",
         buttons: true,
         dangerMode: true,
     })
         .then((willDelete) => {
             if (willDelete) {
                 swal("اوه!  حذف شد!", {
                     icon: "success",
                 });
             } else {
                 swal("فایل شما هنوز وجود دارد !", {
                     icon: "error",
                 });
             }
         });

}

  $(".js-create-assetFailure").click(myWoLoader);
  $("#modal-company").on("submit", ".js-assetFailure-create-form", saveForm);

  // Update book
  $("#company-table").on("click", ".js-update-assetFailure", myWoLoader);
  $("#modal-company").on("submit", ".js-assetFailure-update-form", saveForm);
  $("#modal-company").on("submit", ".js-AssetFailure-delete-form", saveForm);

  // Delete book js-assetFailure-delete
  // $("#company-table").on("click", ".js-delete-assetFailure", loadForm);
  $("#company-table").on("click", ".js-assetFailure-delete", myWoLoader);
  });
