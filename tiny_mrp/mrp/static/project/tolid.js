
// document.addEventListener('DOMContentLoaded', function() {
//   const tables = document.querySelectorAll('.company-table');
//
//   // Function to handle cell value change in the second column
//   const handleCellValueChange = (event) => {
//     const changedValue = event.target.innerText;
//     const columnIndex = Array.from(event.target.parentElement.children).indexOf(event.target);
//
//     if (columnIndex === 1) { // Assuming the second column is index 1 (0-indexed)
//       tables.forEach((table) => {
//         const rows = table.querySelectorAll('tr');
//         const cellToUpdate = rows[event.target.parentElement.rowIndex].querySelectorAll('.editable-cell')[0];
//         if (cellToUpdate && cellToUpdate !== event.target) {
//           // cellToUpdate.innerText = changedValue;
//           // cellToUpdate.attr('data-nomre',changedValue);
//           cellToUpdate.setAttribute('data-nomre', changedValue);
//
//         }
//       });
//     }
//   };
//
//   // Add event listeners to detect cell value changes in the second column
//   tables.forEach((table) => {
//     const cells = table.querySelectorAll('.editable-cell');
//     cells.forEach((cell) => {
//       cell.addEventListener('input', handleCellValueChange);
//     });
//   });
//
// });

// document.addEventListener('DOMContentLoaded', function() {
//   const cells = document.querySelectorAll('.editable-cell');

//   // Function to select all text in an editable cell when clicked
//   const selectText = (event) => {
//     const selection = window.getSelection();
//     const range = document.createRange();
//     range.selectNodeContents(event.target);
//     selection.removeAllRanges();
//     selection.addRange(range);
//   };

//   // Add click event listener to each editable cell



//   // Add event listeners to detect keypress in cells
//   cells.forEach((cell) => {
//     cell.addEventListener('click', selectText);


//   });
// });
// document.addEventListener('DOMContentLoaded', function() {
//   const cells = document.querySelectorAll('.company-table .editable-cell');

//   // Function to handle key press
//   const handleKeyPress = (event) => {
//     if (event.key === 'Enter') {
//       event.preventDefault(); // Prevent default Enter behavior (line break)

//       const cellIndex = Array.from(cells).indexOf(event.target);
//       const rows = Array.from(event.target.parentElement.parentElement.children);
//       const rowIndex = rows.indexOf(event.target.parentElement);
//       const nextRow = rows[rowIndex + 1];

//       if (nextRow) {
//         const nextCell = nextRow.querySelector('.counter');
//         if (nextCell) {
//           nextCell.focus();
//           window.getSelection().selectAllChildren(nextCell);
//         }
//       }
//     }
//   };

//   // Add event listeners to detect keypress in cells
//   cells.forEach((cell) => {
//     cell.addEventListener('keydown', handleKeyPress);
//   });
// });


$(function () {
  $('#tblrows').on('keydown','.editable-cell, .production',(function(e) {
        if (e.keyCode == 13) { // Enter key
            e.preventDefault(); // Prevent default Enter behavior

            var $currentCell = $(this);
            var $nextRow = $currentCell.closest('tr').next('tr');

            if ($nextRow.length) {
                // Find the same index cell in the next row and focus it
                var cellIndex = $currentCell.index();
                var $nextCell = $nextRow.find('td').eq(cellIndex);

                if ($nextCell.length && $nextCell.is('[contenteditable=true]')) {
                    $nextCell.focus();
                }
            }
        }
    }));


  var handleCellValueChange = function(event) {
     const tables = $('.company-table');

    const changedValue = $(event.target).text();
    const columnIndex = $(event.target).index();

    if (columnIndex === 1) { // Assuming the second column is index 1 (0-indexed)
      tables.each(function() {
        const rows = $(this).find('tr');
        const cellToUpdate = $(rows[event.target.parentElement.rowIndex]).find('.editable-cell').eq(0);
        if (cellToUpdate.length && cellToUpdate[0] !== event.target) {
          // cellToUpdate.text(changedValue);
          // cellToUpdate.attr('data-nomre', changedValue);
          cellToUpdate.attr('data-nomre', changedValue);
          console.log("change");
        }
      });
    }
  };
  $(".tab-content").on("input",'.btc', function() {
            var row = $(this).closest("tr");
            var nomre = parseFloat(row.find(".nomre").text()) || 0;
            
            var counter1 = parseFloat(row.find(".counter1").text()) || 0;
            var counter2 = parseFloat(row.find(".counter2").text()) || 0;
            // var vahed = parseInt(row.find(".vahed").text()) || 0;
            var z = parseFloat(row.find(".speed").text()) || 0;
            var p = parseFloat(row.find(".nomre").text()) || 0;
            var q = parseFloat(row.find(".vahed").text()) || 0;
            var formula2 = row.find("[data-maxformula]").data("maxformula");
            var formula = row.find(".production").data("formula");
            // console.log(nomre);
            var result = evaluateFormula(formula, nomre,q, counter2-counter1);
            row.find("[data-formula]").text(result);
            var result = evaluateFormula2(formula2, z, p,q);
            row.find(".production_full").text(result);


        });

        function evaluateFormula(formula, P, Q,Z) {
          console.log(formula,P,Q,Z);
            formula = formula.replace("P", P).replace("Q", Q).replace("Z",Z);
            try {
              // console.log(formula);
                var result = eval(formula);
                console.log(result)
                return result.toFixed(2); // Adjust as needed
            } catch (error) {
                console.error("Error evaluating formula:", error);
                return "Error";
            }
        }
  // $(".tab-content").on("input",'.editable-cell2', function(event) {
  //           var row = $(this).closest("tr");
  //           var z = parseFloat(row.find(".speed").text()) || 0;
  //           var p = parseFloat(row.find(".nomre").text()) || 0;
  //           var q = parseFloat(row.find(".vahed").text()) || 0;
  //           var formula = row.find("[data-maxformula]").data("maxformula");
  //           // console.log( Array.from(event.target.parentElement.parentElement.children).indexOf(event.target.parentElement));
  //           const rowIndex = Array.from(event.target.parentElement.parentElement.children).indexOf(event.target.parentElement);
  //           const tables = document.querySelectorAll('.company-table');
  //           // console.log(tables);
  //           console.log(rowIndex);

  //           for (let i = 0; i < tables.length; i++) {
  //             const correspondingCell = tables[i].querySelectorAll('.editable-cell.editable-cell')[rowIndex];

  //             if (correspondingCell && correspondingCell !== event.target) {
  //                       // console.log(correspondingCell);
  //                      // correspondingCell.innerText = newValue;
  //                      // console.log(correspondingCell);
  //                      // const correspondingRow = correspondingCell.closest('tr');
  //                      // console.log(correspondingRow);
  //                      // correspondingRow.setAttribute('data-speed',z);
  //                      tables[i].rows[rowIndex+1].setAttribute('data-speed2',z);



  //                    }

  //           }


  //           ///
  //           var result = evaluateFormula2(formula, z, p,q);
  //           row.find(".production_full").text(result);

  //       });

        function evaluateFormula2(formula, Z, P,Q) {
          console.log(formula,Z,P);
            formula = formula.replace("Z", Z).replace("p", P).replace("Q",Q);
            try {
                var result = eval(formula);
                return result.toFixed(2); // Adjust as needed
            } catch (error) {
                console.error("Error evaluating formula:", error);
                return "Error";
            }
        }



        $('#search').pDatepicker({
                format: 'YYYY-MM-DD',
                autoClose: true,
                initialValueType: 'gregorian'
              });

//$("#company-table").on("click", ".js-update-wo", initxLoad);
var tableDataToJSON=function(tableId){
  var $table = $(tableId);
  var data = [];
  $table.find('tr').each(function() {
        if($(this).attr('data-machine')){
        var machine=$(this).attr('data-machine');
        var amar_id=$(this).attr('data-id')||'0';
        var shift = $("#select_shift").val();
        var dayOfIssue = $("#search").val();
        var speed = $(this).find('td.speed').text()||0;        
        var nomre = parseFloat($(this).find('td.nomre').text());
        // var nomre=100;
        // console.log($(this).find('td.nomre').text());
        var counter1 = $(this).find('td.counter1').text()||0;
        var counter2 = $(this).find('td.counter2').text()||0;
        var vahed = parseInt($(this).find('td.vahed').text()||0);
        var actual_vahed = $(this).find('td.editable-cell').attr('data-vahed');
        // if(vahed > actual_vahed){
        //   toastr.error(`${vahed} ${actual_vahed}`);
        //   return;
        // }
        var production_value =  $(this).find('td.production').text()||0;


        data.push({id:amar_id, machine: machine, shift: shift,dayOfIssue: dayOfIssue, speed: speed,nomre: nomre
          , counter1: counter1, counter2: counter2,production_value: production_value,vahed:vahed
           });
         }
      });

      return data;


}
$("#save_production").click(function(){
   var sendData = {
    
  };
  var i=1;
  $("table.company-table").each(function() {
    
    // You can perform operations on each table here
    // console.log($(this)); // This logs each table with the class 'company-table'
    
    sendData[i]=tableDataToJSON($(this));
    i++;
});


console.log(JSON.stringify(sendData));
  // AJAX request to send data to the server
  $.ajax({
    url: '/Tolid/SaveTableInfo',
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
  // var tbl2=tableDataToJSON('tbl2');
  // var tbl3=tableDataToJSON('tbl3');
});
  function processDataFromTables() {
    const tables = $('.tbl-zayeat-vazn'); // Select all tables with class 'table'
    const allTableData = []; // Array to store data from all tables

    tables.each(function() {
        const tableData = []; // Array to store data from a single table
        const rows = $(this).find('tbody tr'); // Find rows in the current table

        rows.each(function() {
            const rowData = {}; // Object to store data for a single row

            // Find cells in the current row
            const cells = $(this).find('td');

            cells.each(function(index) {
              const dataId = $(this).attr('data-id');
              const cellContent = $(this).text().trim()||0;
              const datadate = $(this).attr('data-date');
              const shiftdata=$(this).attr('data-shift');

              tableData.push({'id':dataId,'vazn':cellContent,'date':datadate,'shift':shiftdata});
            });

            // Push rowData object to the tableData array

        });

        // Push tableData array to the allTableData array
        allTableData.push(tableData);
    });

    return allTableData;
}
  var save_zayeat=function(){
    form=$(this);

    // Initialize an empty array to store the data
            const collectedData = processDataFromTables();
            console.log(collectedData);
            const url = form.attr('action'); // Replace with your actual POST endpoint URL

            $.ajax({
              url: form.attr("action"),
              data: JSON.stringify(collectedData),
              type: form.attr("method"),
              dataType: 'json',
              success: function (data) {
                console.log(data);
                if(data.success==true)
                 $("#modal-company").modal("hide");
                else{
                  console.log(data);
                }


              }
            });
            return false;

  }
  $(".add-zayeat").click(function(){
    var btn=$(this);
    return $.ajax({
      url: $(btn).attr("data-url")+'?data='+$("#search").val(),
      type: 'get',
      dataType: 'json',
      beforeSend: function () {
        //alert(btn.attr("data-url"));
        //alert("321321");
        // /$("#modal-maintenanceType").modal("hide");
        $("#modal-company").modal("show");
      },
      success: function (data) {
        console.log(data);
        //alert("3123@!");
        $("#modal-company .modal-content").html(data.data);

      }
    });
  });
  $("#button-addon1").click(function(){

    var btn=$(this);
    return $.ajax({
      url: $(btn).attr("data-url")+'?event_id='+$("#search").val()+'&shift_id='+$("#select_shift").val(),
      type: 'get',
      dataType: 'json',
      beforeSend: function () {
        //alert(btn.attr("data-url"));
        //alert("321321");
        // /$("#modal-maintenanceType").modal("hide");

      },
      success: function (data) {
        console.log(data);
    $(".tab-content").empty();
    $(".tab-content").html(data.html_heatset_result);
    $("#btn_next_date").attr('data-url',`/Tolid/Asset/LoadInfo?event=${data.next_date}&shift_id=${$("#select_shift").val()}`);
    $("#btn_prev_date").attr('data-url',`/Tolid/Asset/LoadInfo?event=${data.prev_date}&shift_id=${$("#select_shift").val()}`);
    $('.nav-link.active').removeClass('active').attr('aria-selected', false);
    $a = $($(".nav-item a")[0]); // Wrap the first DOM element in a jQuery object
    $a.addClass('active').attr('aria-selected', true).tab('show');


      }
    });
  }
);
$(".page-link").click(function(){
  var btn=$(this);
  console.log(btn.attr("data-url"));
  return $.ajax({
    url: $(btn).attr("data-url"),
    type: 'get',
    dataType: 'json',
    beforeSend: function () {
      //alert(btn.attr("data-url"));
      //alert("321321");
      // /$("#modal-maintenanceType").modal("hide");

    },
    success: function (data) {

      $(".tab-content").empty();
      // console.log(data.html_heatset_result);
      $(".tab-content").html(data.html_heatset_result);
      $("#btn_next_date").attr('data-url',`/Tolid/Asset/LoadInfo?event=${data.next_date}&shift_id=${$("#select_shift").val()}`);
      $("#btn_prev_date").attr('data-url',`/Tolid/Asset/LoadInfo?event=${data.prev_date}&shift_id=${$("#select_shift").val()}`);
      $("#search").val(data.today_shamsi);
      $('.nav-link.active').removeClass('active').attr('aria-selected', false);
      $a = $($(".nav-item a")[0]); // Wrap the first DOM element in a jQuery object
      $a.addClass('active').attr('aria-selected', true).tab('show');


    }
  });

});
$(".delete-info").click(function(){
  var btn=$(this);
  return $.ajax({
    url: $(btn).attr("data-url")+'?event_id='+$("#search").val(),
    type: 'get',
    dataType: 'json',
    beforeSend: function (x) {
      //alert(btn.attr("data-url"));
      //alert("321321");
      // /$("#modal-maintenanceType").modal("hide");
      a=confirm("آیا مظمئن هستید؟همه اطلاعات این تاریخ حذف خواهد شد!");
      if(!a){
        x.abort();
      }

    },
    success: function (data) {
      $("#tblrows").empty();
      $("#tblrows").html(data.html_heatset_result);

    }
  });
});
  // $('.editable-cell').on('input', function() {
  //       // Allow only numeric input
  //       var text = $(this).text();
  //       $(this).text(text.replace(/[^0-9]/g, ''));
  //   });
  $("#modal-company").on("submit",'.js-zayeatVazn-create-form',save_zayeat);
   $(".tblrows").on('input','.editable-cell', handleCellValueChange);
  $("#new_amar").click(function(){
    window.location='/Register';
  });
  $("#select_shift").change(function(){
    window.location='/Register?shift_id='+$(this).val();
  });
  function getQueryParameter(name) {
    let results = new RegExp('[?&]' + name + '=([^&#]*)').exec(window.location.href);
    return results ? decodeURIComponent(results[1]) : null;
}
  $("#select_shift2").change(function(){
    window.location=`/Tolid/DailyDetails?event_id=${getQueryParameter('event_id')}&shift_id=${$(this).val()}`;
  });
});
