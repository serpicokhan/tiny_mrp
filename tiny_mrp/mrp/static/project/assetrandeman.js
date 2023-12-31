
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

          $("#modal-company .modal-content").html(data.html_assetRandeman_form);
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
           $("#tbody_company").html(data.html_assetRandeman_list);
           $("#modal-company").modal("hide");
         }
         else {

           $("#company-table tbody").html(data.html_assetRandeman_list);
           $("#modal-company .modal-content").html(data.html_assetRandeman_form);
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
  var delete_asset_randeman=function(){
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

  $(".js-create-assetRandeman").click(myWoLoader);
  $("#modal-company").on("submit", ".js-assetRandeman-create-form", saveForm);

  // Update book
  $("#company-table").on("click", ".js-update-assetRandeman", myWoLoader);
  $("#modal-company").on("submit", ".js-assetRandeman-update-form", saveForm);
  // Delete book
  $("#company-table").on("click", ".js-delete-assetRandeman", loadForm);
  $("#company-table").on("click", ".js-assetRandeman-delete", myWoLoader);
  $("#modal-company").on("submit", ".js-assetRandeman-delete-form", saveForm);

  });
