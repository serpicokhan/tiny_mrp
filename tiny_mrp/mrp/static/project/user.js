
$(function () {


    var loadForm =function (btn1) {
     
      // alert("123");
      return $.ajax({
        url: $(this).attr("data-url"),
        type: 'get',
        dataType: 'json',
        beforeSend: function () {
          
          $("#modal-company").modal("show");
  
        },
        success: function (data) {
          console.log(data);
          
          $("#modal-company .modal-content").html(data.html_user_form);
          // var elem = document.querySelector('.js-switch');
          // var init = new Switchery(elem);
          // $("#id_userStatus").change(function(){
          //   js_switch_change();
          // });
        }
  
      });
  };
  
  
  
  var saveForm= function (e) {
       e.preventDefault();
       var form2 = $(this);
  
     var form = new FormData(document.getElementById("userform"));
     // console.log(form);
     $.ajax({
       url: form2.attr("action"),
       data: form,
       type: form2.attr("method"),
       dataType: 'json',
       cache:false,
       contentType: false,
       processData: false,
       success: function (data) {
         if (data.form_is_valid) {
          $("#tbody_company").empty();
          $("#tbody_company").html(data.html_user_list);
          $("#modal-company").modal("hide");
  
  
         }
         else {
           $("#company-table tbody").html(data.html_user_list);
           $("#modal-company .modal-content").html(data.html_user_form);
         }
       },
       error:function(x,y,z)
       {
         alert(x.status);
       }
     });
     return false;
   };
   var saveForm2= function () {
      var form = $(this); 
      console.log(form.serialize());
      $.ajax({
        url: form.attr("action"),
        data: form,
        type: form.attr("method"),
        dataType: 'json',
        success: function (data) {
          if (data.form_is_valid) {
            $("#tbody_company").empty();
            $("#tbody_company").html(data.html_user_list);
            $("#modal-company").modal("hide");
  
          }
          else {
            $("#tbody_company").empty();
          }
        },
        error:function(x,y,z)
        {
          alert("error: "+y);
        }
      });
      return false;
    };
    var saveForm3= function () {
        var form = $(this);
     
        $.ajax({
          url: form.attr("action"),
          data: form.serialize(),
          type: form.attr("method"),
          dataType: 'json',
          success: function (data) {
            if (data.form_is_valid) {
              //alert("Company created!");  // <-- This is just a placeholder for now for testing
              $("#tbody_company").empty();
              $("#tbody_company").html(data.html_user_list);
              $("#modal-company").modal("hide");
             // console.log(data.html_maintenanceType_list);
            }
            else {
     
              $("#company-table tbody").html(data.html_user_list);
              $("#modal-company .modal-content").html(data.html_user_list);
            }
          }
        });
        return false;
      };
   var initUserGroupsLoad=function(){
  
     $.ajax({
       url: '/UserGroups/'+$("#lastUserId").val()+'/listUserGroups',
       success: function (data) {
         if (data.form_is_valid) {
           $("#tbody_userGroup").empty();
           $("#tbody_userGroup").html(data.html_userGroup_list);
           $("#modal-userGroup").modal("hide");
         }
         else {
           $("#userGroup-table tbody").html(data.html_userGroup_list);
           $("#modal-userGroup .modal-content").html(data.html_userGroup_form);
         }
       }
     });
   return false;
   };
  
  
   var myWoLoader= function(){
     btn=$(this);
     $.when(loadForm(btn)).done(initUserGroupsLoad,initUserFileLoad,initUserCertLoad,initUserLogLoad);
   }
  
  
  
  ///////////////////////////////
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  $(".js-create-user").click(loadForm);
  $("#modal-company").on("submit", ".js-user-create-form", saveForm);
  
  // Update book
  $(document).on("click", ".js-update-user", loadForm);
  $("#modal-company").on("submit", ".js-user-update-form", saveForm);
  // Delete book
  $(document).on("click", ".js-delete-user", loadForm);
  $("#modal-company").on("submit", ".js-user-delete-form", saveForm3);
  //$("#company-table").on("click", ".js-update-user", initxLoad);
  });
  