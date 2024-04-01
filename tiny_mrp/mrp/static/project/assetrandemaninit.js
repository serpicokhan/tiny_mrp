
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
     



     loadForm(btn);

   }
   var update_val=function(){
    // $("#id_max_randeman")
    $("#id_randeman_yek_dastgah").val($("#id_max_randeman").val()*$("#id_operator_count").val());
    $("#id_randeman_mazrab_3").val($("#id_randeman_yek_dastgah").val()*3);

   }
   var tableDataToJSON=function(tableId){
    var data = [];
    
        $('#' + tableId + ' tr').each(function() {
          if($(this).attr('data-id')){
            var row=$(this);
            var id=$(row).attr('data-id');
            var carding = $(row).find('td:eq(0)').text() || 0;
            var operatorCount = $(row).find('td:eq(1)').text() || 0;
            var maxRandeman = $(row).find('td:eq(2)').text() || 0;
            var randemanYekDastgah = $(row).find('td:eq(3)').text() || 0;
            var randemanMazrab3 = $(row).find('td:eq(4)').text() || 0;
            var mablagheKoleRandeman = $(row).find('td:eq(5)').text() || 0;
            var mablagheKoleRandemanRound = $(row).find('td:eq(6)').text() || 0;
            var randemanTolid = $(row).find('td:eq(7)').text() || 0;
  
          data.push({id:id, carding: carding, operatorCount: operatorCount,maxRandeman: maxRandeman, randemanYekDastgah: randemanYekDastgah,randemanMazrab3: randemanMazrab3
            , mablagheKoleRandeman: mablagheKoleRandeman,mablagheKoleRandemanRound: mablagheKoleRandemanRound,randemanTolid:randemanTolid
             });
           }
        });
  
        return data;
  
  
  }
  $("#save_production").click(function(){
    
    var tbl1=tableDataToJSON('tbody_company');
    var sendData = {
      table1: tbl1      
    };
  console.log(JSON.stringify(sendData));
    // AJAX request to send data to the server
    $.ajax({
      url: 'Asset/Randeman/InitRandeman/SaveTableInfo',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(sendData),
      beforeSend:function(){
        $(".preloader").show();
      },
      success: function(response) {
        // Handle the success response from the server
        if(response.error)
        {
          toastr.error(response.error);
        }
        else{
          console.log('Data sent successfully:', response);
          toastr.success("اطلاعات با موفقیت ذخیره شد");
  
        }
        $(".preloader").hide();
      },
      error: function(xhr, status, error) {
        // Handle any errors that occur during the AJAX request
        console.error('Error sending data:', error);
        toastr.error(error);
        $(".preloader").hide();
      }
    });


   
   var redirect_to_tolid_padash=function(){
  
    window.location=`/Asset/Randeman/InitRandeman/?profile=${$("#profile_year").val()}`;
  }
  $("#go_to_profile").click(function(){
    redirect_to_tolid_padash();
  });
  // $(".js-create-assetFailure").click(myWoLoader);
  // $("#modal-company").on("submit", ".js-assetFailure-create-form", saveForm);

  // // Update book
  $("#company-table").on("click", ".js-update-assetRandeman", myWoLoader);
  $("#modal-company").on("submit", ".js-assetRandemanInit-update-form", saveForm);
  $("#modal-company").on("input", "#id_max_randeman", update_val);
  // $("#modal-company").on("submit", ".js-AssetFailure-delete-form", saveForm);

  // // Delete book js-assetFailure-delete
  // // $("#company-table").on("click", ".js-delete-assetFailure", loadForm);
  // $("#company-table").on("click", ".js-assetFailure-delete", myWoLoader);
  });
