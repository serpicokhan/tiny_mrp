
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
          $("#modal-company2").modal("show");
        },
        success: function (data) {
          

          $("#modal-company2 .modal-content").html(data.html_form);
            $("#id_color").select2({
              placeholder: "انتخاب رنگ", // Optional: Add a placeholder
              allowClear: true,              // Optional: Allow clearing the selection
              width: '100%',
              dropdownParent: $('#modal-company2')                  // Optional: Ensure proper width
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
          //  $("#tbody_company2").empty();
          //  $("#tbody_company2").html(data.html_moshakhase_list);
           $("#modal-company2").modal("hide");
           refreshList2();
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
     



     loadForm(btn);

   }
   function refreshList2() {
    const currentParams = new URLSearchParams(window.location.search);

    // Save them globally for later use
    const filters = {};
    for (const [key, value] of currentParams.entries()) {
        filters[key] = value;
    }
    // Send the query parameters with the list reload request
    const params = new URLSearchParams(filters).toString();

    $.ajax({
        url: `/Moshakhase/RefereshList?${params}`, // Append filters to the URL
        method: 'GET',
        success: function (data) {
            // $('#list-container').html(data.parchase_req_html);
            if(data.status="ok"){
              console.log(data);
              $("#tbody_company2").empty();

              $("#tbody_company2").html(data.html_moshakhase_list);
            }
        },
    });
    console.log(params);
}


  // // Update book
  $(".js-create-moshakhase").click(myWoLoader);
  $("#moshakhase-table").on("click", ".js-update-moshakhase", myWoLoader);
  $("#moshakhase-table").on("click", ".js-delete-moshakhase", myWoLoader);
  $("#modal-company2").on("submit", ".js-moshakhase-update-form", saveForm);
  $("#modal-company2").on("submit", ".js-moshakhase-create-form", saveForm);
  $("#modal-company2").on("submit", ".js-moshakhase-delete-form", saveForm);

  });
