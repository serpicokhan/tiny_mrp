
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
          if(data.form_error){
            toastr.error(data.form_error);
          }

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
    initialValueType: 'gregorian',
    calendar:{
      persian: {
          leapYearMode: 'astronomical'
      }
    }
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
var save_ranking=function () {
  var dataArray = [];
  var form = $(this);

  // Iterate through each list item
  $('#tbody_sortable tr').each(function() {
      var dataId = $(this).data('id');
      var dataPosition = $(this).find('td:eq(1) .rank').val()||0;
      var nezafatpadash_sarshift=$(this).find('td:eq(2) input').val()||0
      var nezafatdash_operator=$(this).find('td:eq(3) input').val()||0
      var data_asset_randeman_list= $(this).data('assetrandeman');

      // Create an object with data-id and data-position
      var itemData = {
          id: dataId,
          position: dataPosition,
          nezafatdash_sarshift: nezafatpadash_sarshift,
          nezafatdash_operator: nezafatdash_operator,
          assetrandeman:data_asset_randeman_list
      };

      // Add the object to the dataArray
      dataArray.push(itemData);
  });
  var sent_data={items:dataArray};

  // Use AJAX to send the dataArray to your server
  $.ajax({
      url: form.attr("action"),

      type: form.attr("method"),
      data: JSON.stringify(dataArray),
      beforeSend:function(){
        console.log(dataArray);
      },
      success: function(response) {
          console.log('Data sent successfully', response);
          if(response.status=='success')
          $("#modal-company").modal("hide");

      },
      error: function(error) {
          console.error('Error sending data', error);
      }
  });
  return false;
 };
 var save_ranking_v2 = function(event) {
  event.preventDefault(); // جلوگیری از ارسال فرم به روش معمول
  var dataArray = [];
  var form = $(this);

  // بررسی وجود رکوردها
  var rowCount = $('tr[data-id]').length;
  if (rowCount === 0) {
    alert('هیچ داده‌ای برای ذخیره‌سازی وجود ندارد');
    return false;
  }

  // جمع‌آوری داده‌ها از تمام تب‌ها
  $('.tab-pane').each(function(tabIndex) {
    $(this).find('tr[data-id]').each(function(rowIndex) {
      var $row = $(this);
      var dataId = $row.data('id');
      
      // بررسی وجود ID
      if (!dataId) {
        console.warn('ردیف بدون ID پیدا شد:', $row);
        return; // ادامه به ردیف بعدی
      }

      var rank = $row.find('.rank').val();
      var price_sarshift = $row.find('.sarshift_val').val() || 0;
      var price_personnel = $row.find('.operator_val').val() || 0;
      var asset_randeman = $row.data('assetrandeman');

      // اعتبارسنجی داده‌ها
      if (!rank) {
        alert('لطفا رتبه را برای تمام سطرها مشخص کنید');
        return false;
      }

      var itemData = {
        id: dataId,
        rank: parseInt(rank),
        price_sarshift: parseFloat(price_sarshift),
        price_personnel: parseFloat(price_personnel),
        asset_randeman: asset_randeman
      };

      dataArray.push(itemData);
    });
  });

  // نمایش داده‌ها در کنسول برای دیباگ
  console.log('Data to be sent:', dataArray);

  // نمایش loading
  var submitBtn = form.find('button[type="submit"]');
  var originalText = submitBtn.text();
  submitBtn.prop('disabled', true).text('در حال ذخیره‌سازی...');

  // ارسال درخواست
  $.ajax({
    url: form.attr("action"),
    type: "POST",
    data: JSON.stringify(dataArray),
    contentType: "application/json",
    // headers: {
    //   'X-CSRFToken': getCookie('csrftoken')
    // },
    success: function(response) {
      console.log('Server response:', response);
      
      if (response.status === 'success') {
        alert('داده‌ها با موفقیت ذخیره شدند');
        $("#modal-company").modal("hide");
        // ریلود صفحه یا به‌روزرسانی داده‌ها در صورت نیاز
        if (typeof reloadRankingData === 'function') {
          reloadRankingData();
        }
      } else if (response.status === 'partial') {
        alert('تعداد ' + response.success_count + ' رکورد ذخیره شد. ' + 
              response.error_count + ' خطا وجود داشت.');
        if (response.errors) {
          console.error('Errors:', response.errors);
        }
      } else {
        alert('خطا در ذخیره‌سازی: ' + (response.message || 'خطای ناشناخته'));
      }
    },
    error: function(xhr, status, error) {
      console.error('AJAX Error:', error);
      alert('خطا در ارتباط با سرور. لطفا دوباره تلاش کنید.');
    },
    complete: function() {
      // بازگرداندن دکمه به حالت عادی
      submitBtn.prop('disabled', false).text(originalText);
    }
  });
  
  return false;
};
 var calc_ranking=function () {
  var dataArray = [];
  var form = $("#ssetRandeman-ranking-form");

  // Iterate through each list item
  $('#tbody_sortable tr').each(function() {
      var dataId = $(this).data('id');
      var dataPosition = $(this).find('td:eq(1) .rank').val()||0;
      var nezafatpadash_sarshift=$(this).find('td:eq(2) input').val()||0
      var nezafatdash_operator=$(this).find('td:eq(3) input').val()||0
      var data_asset_randeman_list= $(this).data('assetrandeman');

      // Create an object with data-id and data-position
      var itemData = {
          id: dataId,
          position: dataPosition,
          nezafatdash_sarshift: nezafatpadash_sarshift,
          nezafatdash_operator: nezafatdash_operator,
          assetrandeman:data_asset_randeman_list
      };

      // Add the object to the dataArray
      dataArray.push(itemData);
  });
  var sent_data={items:dataArray};

  // Use AJAX to send the dataArray to your server
  $.ajax({
      url: $(this).attr("data-url"),

      type: 'post',
      data: JSON.stringify(dataArray),
      beforeSend:function(){
        console.log(dataArray);
      },
      success: function(data) {
          console.log('Data sent successfully', data);
          if(data.status=='1'){
            if(data.result){
              for( var i in data.result){
                var targetRow = $(`tr[data-id="${data.result[i].id}"]`);
                
                targetRow.find('input.sarshift_val').val(Math.ceil(data.result[i].price_sarshift));
                targetRow.find('input.operator_val').val(Math.ceil(data.result[i].price_personnel));
              }
            }
          }
          


      },
      error: function(error) {
          console.error('Error sending data', error);
      }
  });
  return false;
 };
 var calc_ranking_v2 = function() {
  var dataArray = [];
  var button = $(this);
  var url = button.attr("data-url");
    console.log(2);

  // Iterate through each tab content
  $('.tab-pane').each(function() {
    // Iterate through each list item in this tab
    $(this).find('tr[data-id]').each(function() {
      console.log(1);
      
      var $row = $(this);
      var dataId = $row.data('id');
      var rank = $row.find('.rank').val() || 0;
      var price_sarshift = $row.find('.sarshift_val').val() || 0;
      var price_personnel = $row.find('.operator_val').val() || 0;
      var data_asset_randeman_list = $row.data('assetrandeman');

      var itemData = {
        id: dataId,
        rank: rank,
        price_sarshift: price_sarshift,
        price_personnel: price_personnel,
        asset_randeman: data_asset_randeman_list
      };

      dataArray.push(itemData);
    });
  });

  // Use AJAX to send the dataArray to your server
  $.ajax({
    url: url,
    type: 'POST',
    data: JSON.stringify(dataArray),
    contentType: 'application/json',
    // headers: {
    //   'X-CSRFToken': getCookie('csrftoken')
    // },
    beforeSend: function() {
      console.log('Sending data for calculation:', dataArray);
    },
    success: function(data) {
      console.log('Calculation response:', data);
      
      if (data.status === 'success' || data.status === '1') {
        if (data.result) {
          for (var i = 0; i < data.result.length; i++) {
            var resultItem = data.result[i];
            var targetRow = $(`tr[data-id="${resultItem.id}"]`);
            
            if (targetRow.length > 0) {
              targetRow.find('input.sarshift_val').val(Math.ceil(resultItem.price_sarshift));
              targetRow.find('input.operator_val').val(Math.ceil(resultItem.price_personnel));
            }
          }
          alert('محاسبه با موفقیت انجام شد');
        }
      } else {
        alert('خطا در محاسبه: ' + (data.message || 'خطای ناشناخته'));
      }
    },
    error: function(error) {
      console.error('Error sending data', error);
      alert('خطا در ارتباط با سرور');
    }
  });
  
  return false;
};

// تابع برای دریافت CSRF token

  $(".js-create-assetRandeman").click(myWoLoader);
  $("#modal-company").on("submit", ".js-assetRandeman-create-form", saveForm);

  // Update book
  $("#company-table").on("click", ".js-update-assetRandeman", myWoLoader);
  $("#company-table").on("click", ".js-update-assetRandemanRanking", myWoLoader);
  $("#modal-company").on("submit", ".js-assetRandeman-update-form", saveForm);
  // Delete book
  $("#company-table").on("click", ".js-delete-assetRandeman", loadForm);
  $("#company-table").on("click", ".js-assetRandeman-delete", myWoLoader);
  $("#modal-company").on("submit", ".js-assetRandeman-delete-form", saveForm);
  $("#modal-company").on("submit", ".js-assetRandeman-ranking-form", save_ranking);
  $("#modal-company").on("submit", ".js-assetRandeman-ranking-form_v2", save_ranking_v2);
  $("#modal-company").on("click", ".js-calc_assetRandeman_nezafat_ranking", calc_ranking);
  $("#modal-company").on("click", ".js-calc_assetRandeman_nezafat_ranking_v2", calc_ranking_v2);

  });
