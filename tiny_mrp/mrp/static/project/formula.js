
$(function () {

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
        url: `/Formula/RefereshList?${params}`, // Append filters to the URL
        method: 'GET',
        success: function (data) {
            // $('#list-container').html(data.parchase_req_html);
            if(data.status="ok"){

              // $("#tbody_company").empty();
              //  $("#tbody_company").html(data.html_formula_list);
            $("#tbody_company").html('');
            $("#tbody_company").html(data.formula_html);
            }
        },
    });
    console.log(params);
}
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

          $("#modal-company .modal-content").html(data.html_formula_form);
         
       

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
          //  $("#tbody_company").empty();
          //  $("#tbody_company").html(data.html_formula_list);
           $("#modal-company").modal("hide");
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
     console.log(1);



     loadForm(btn);

   }
   $("#makan_filter").click(function(){
    window.location="/Formula/?makan="+$("#id_makan").val();
   });

  // // Update book
  $("#company-table").on("click", ".js-update-formula", myWoLoader);
  $("#modal-company").on("submit", ".js-formula-update-form", saveForm);

  });
