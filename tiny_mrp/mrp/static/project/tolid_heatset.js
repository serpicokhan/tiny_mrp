
document.addEventListener('DOMContentLoaded', function() {
  const tables = document.querySelectorAll('.company-table');

  // Function to handle cell value change in the second column
  const handleCellValueChange = (event) => {
    const changedValue = event.target.innerText;
    const columnIndex = Array.from(event.target.parentElement.children).indexOf(event.target);

    if (columnIndex === 1) { // Assuming the second column is index 1 (0-indexed)
      tables.forEach((table) => {
        const rows = table.querySelectorAll('tr');
        const cellToUpdate = rows[event.target.parentElement.rowIndex].querySelectorAll('.editable-cell')[0];
        if (cellToUpdate && cellToUpdate !== event.target) {
          // cellToUpdate.innerText = changedValue;
          // cellToUpdate.attr('data-nomre',changedValue);
          cellToUpdate.setAttribute('data-nomre', changedValue);

        }
      });
    }
  };

  // Add event listeners to detect cell value changes in the second column
  tables.forEach((table) => {
    const cells = table.querySelectorAll('.editable-cell');
    cells.forEach((cell) => {
      cell.addEventListener('input', handleCellValueChange);
    });
  });

});

document.addEventListener('DOMContentLoaded', function() {
  const cells = document.querySelectorAll('.editable-cell');

  // Function to select all text in an editable cell when clicked
  const selectText = (event) => {
    const selection = window.getSelection();
    const range = document.createRange();
    range.selectNodeContents(event.target);
    selection.removeAllRanges();
    selection.addRange(range);
  };

  // Add click event listener to each editable cell



  // Add event listeners to detect keypress in cells
  cells.forEach((cell) => {
    cell.addEventListener('click', selectText);


  });
});
document.addEventListener('DOMContentLoaded', function() {
  const cells = document.querySelectorAll('.company-table .editable-cell');

  // Function to handle key press
  const handleKeyPress = (event) => {
    if (event.key === 'Enter') {
      event.preventDefault(); // Prevent default Enter behavior (line break)

      const cellIndex = Array.from(cells).indexOf(event.target);
      const rows = Array.from(event.target.parentElement.parentElement.children);
      const rowIndex = rows.indexOf(event.target.parentElement);
      const nextRow = rows[rowIndex + 1];

      if (nextRow) {
        const nextCell = nextRow.querySelector('.editable-cell');
        if (nextCell) {
          nextCell.focus();
          window.getSelection().selectAllChildren(nextCell);
        }
      }
    }
  };

  // Add event listeners to detect keypress in cells
  cells.forEach((cell) => {
    cell.addEventListener('keydown', handleKeyPress);
  });
});


$(function () {
  $("#tblrows").on("input",".btc", function() {
            var row = $(this).closest("tr");
            var daf_num = parseFloat(row.find(".daf_num").text()) ||0;
            var dook_vazn = parseFloat(row.find(".dook_weight").text()) || 0;
            var vazne1 = parseFloat(row.find(".weight1").text()) || 0;
            var vazne2 = parseFloat(row.find(".weight2").text()) || 0;
            var vazne3 = parseFloat(row.find(".weight3").text()) || 0;
            var vazne4 = parseFloat(row.find(".weight4").text()) || 0;
            var total_metraj = parseFloat(row.find(".js_daf_metraj_create").attr('data-metraj-total')) || 0;
            // js_daf_metraj_create

            var formula = row.find("[data-formula]").data("formula");

            var result = evaluateFormula(formula, daf_num, dook_vazn,vazne2-vazne1,vazne4-vazne3,total_metraj);
            row.find("[data-formula]").text(result);
        });

        function evaluateFormula(formula, P, Q,R,S,T) {
          console.log(P,Q,R,S);
            formula = formula.replace("P", P).replace("Q", Q).replace("R", R).replace("S", S).replace("T", T);
            try {
              console.log(formula);
                var result = eval(formula);
                return result.toFixed(2); // Adjust as needed
            } catch (error) {
                console.error("Error evaluating formula:", error);
                return "Error";
            }
        }
  $(".editable-cell2").on("input", function(event) {
            var row = $(this).closest("tr");
            var z = parseFloat(row.find(".speed").text()) || 0;
            var p = parseFloat(row.find(".speed").data('nomre')) || 0;
            var formula = row.find("[data-formula]").data("formula");
            // console.log( Array.from(event.target.parentElement.parentElement.children).indexOf(event.target.parentElement));
            const rowIndex = Array.from(event.target.parentElement.parentElement.children).indexOf(event.target.parentElement);
            const tables = document.querySelectorAll('.company-table');
            // console.log(tables);
            console.log(rowIndex);

            for (let i = 0; i < tables.length; i++) {
              const correspondingCell = tables[i].querySelectorAll('.editable-cell.editable-cell')[rowIndex];

              if (correspondingCell && correspondingCell !== event.target) {
                        console.log(correspondingCell);
                       // correspondingCell.innerText = newValue;
                       // console.log(correspondingCell);
                       // const correspondingRow = correspondingCell.closest('tr');
                       // console.log(correspondingRow);
                       // correspondingRow.setAttribute('data-speed',z);
                       tables[i].rows[rowIndex+1].setAttribute('data-speed',z);
                       console.log(rowIndex);
                       console.log(tables[i].rows[rowIndex]);


                     }

            }


            ///
            var result = evaluateFormula2(formula, z, p);
            row.find("[data-formula]").text(result);

        });

        function evaluateFormula2(formula, Z, P) {
            formula = formula.replace("Z", Z).replace("P", P);
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
  var data = [];
      $('#' + tableId + ' tr').each(function() {
        if($(this).attr('data-machine')){
        var machine=$(this).attr('data-machine');
        var shift = $(this).attr('data-shift');
        var dayOfIssue = $("#search").val();
        var daf_num = $(this).attr('daf_num')||0;
        var dook_weight = $(this).find('td.dook_weight').text()||0;
        var speed = $(this).find('td.speed').text()||0;
        var weight1 = $(this).find('td.weight1').text()||0;
        var weight2 = $(this).find('td.weight2').text()||0;
        var weight3 = $(this).find('td.weight3').text()||0;
        var weight4 = $(this).find('td.weight4').text()||0;
        var weight5 = $(this).find('td.vazne_daf').text()||0;
        var vazne_baghi = $(this).find('td.vazne_baghi').text()||0;
        var production_value =  $(this).find('td.production').text()||0;
        var button = $(this).find("button");

     // Check if a button is found in the row
         if (button.length > 0) {
           // Read the data-metraj attribute
           var data_metraj = button.data("metraj");



           // Display the result (you can modify this part based on your needs)

         }
        console.log($(this).find('td.btn.js_daf_metraj_create').attr('data-metraj'));
        // var data_metraj =  JSON.stringify($(this).find('td.js_daf_metraj_create').attr('data-metraj'))||'';
        // console.log(data_metraj);
        var nomre=0;
        var counter=0;



        data.push({ machine: machine, shift: shift,dayOfIssue: dayOfIssue, speed: speed,nomre: nomre
          , counter: counter,production_value: production_value,daf_num:daf_num,dook_weight:dook_weight,
          weight1:weight1,weight2:weight2,weight3:weight3,weight4:weight4,weight5:weight5,vazne_baghi:vazne_baghi,data_metraj:data_metraj
           });
         }
      });
      // console.log(JSON.stringify(data));
      return data;


}
$("#save_production").click(function(){
  var tbl1=tableDataToJSON('tb1');
  var tbl2=tableDataToJSON('tb2');
  var tbl3=tableDataToJSON('tb3');
  var sendData = {
    table1: tbl1,
    table2: tbl2,
    table3: tbl3
  };
console.log(JSON.stringify(sendData));
  // AJAX request to send data to the server
  $.ajax({
    url: '/Tolid/SaveHTableInfo',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(sendData),
    beforeSend:function(){
      $(".preloader").show();
    },
    success: function(response) {
      // Handle the success response from the server
      console.log('Data sent successfully:', response);
      toastr.success("اطلاعات با موفقیت ذخیره شد");

      $(".preloader").hide();
    },
    error: function(xhr, status, error) {
      // Handle any errors that occur during the AJAX request
      console.error('Error sending data:', error);
      $(".preloader").hide();
      toastr.error(error);
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
      url: $(btn).attr("data-url")+'?event_id='+$("#search").val(),
      type: 'get',
      dataType: 'json',
      beforeSend: function () {
        //alert(btn.attr("data-url"));
        //alert("321321");
        // /$("#modal-maintenanceType").modal("hide");

      },
      success: function (data) {
        
    $("#tblrows").empty();
    $("#tblrows").html(data.html_heatset_result);


      }
    });
  }
);
var open_daf_metraj_modal=function(){
  var btn=$(this);
  var json_info=JSON.stringify($(btn).attr("data-metraj"));
  var params=`?data=${json_info}`
  return $.ajax({
    url: $(btn).attr("data-url")+params,
    type: 'get',
    dataType: 'json',
    beforeSend: function () {
    $("#modal-company").modal("show");

    },
    success: function (data) {
        btn.addClass("highlight");
        $("#modal-company .modal-content").html(data.html_heatsetmetraj_form);

    }
  });

}
var save_daf_metraj_heatset_Form= function () {

   var form = $(this);



   $.ajax({
     url: form.attr("action"),
     data: form.serialize(),
     type: form.attr("method"),
     dataType: 'json',
     success: function (data) {

       if (data.form_is_valid) {
         // console.log(data);
          $(".highlight").attr("data-metraj",JSON.stringify(data.data));
          $(".highlight").attr("data-metraj-total",data.total_val);

          var row = $(".highlight").closest("tr");
          var daf_num = parseFloat(row.find(".daf_num").text()) ||0;
          var dook_vazn = parseFloat(row.find(".dook_weight").text()) || 0;
          var vazne1 = parseFloat(row.find(".weight1").text()) || 0;
          var vazne2 = parseFloat(row.find(".weight2").text()) || 0;
          var vazne3 = parseFloat(row.find(".weight3").text()) || 0;
          var vazne4 = parseFloat(row.find(".weight4").text()) || 0;
          var total_metraj = parseFloat(row.find(".js_daf_metraj_create").attr('data-metraj-total')) || 0;


          $(".highlight").removeClass("highlight");
          $("#modal-company").modal("hide");

          // js_daf_metraj_create

          var formula = row.find("[data-formula]").data("formula");

          var result = evaluateFormula(formula, daf_num, dook_vazn,vazne2-vazne1,vazne4-vazne3,total_metraj);
          row.find("[data-formula]").text(result);
       }
       else {

         $("#company-table tbody").html(data.html_assetFailure_list);
         $("#modal-company .modal-content").html(data.html_assetFailure_form);
       }
     }
   });
   return false;
 };
  // $('.editable-cell').on('input', function() {
  //       // Allow only numeric input
  //       var text = $(this).text();
  //       $(this).text(text.replace(/[^0-9]/g, ''));
  //   });
  $("#modal-company").on("submit",'.js-zayeatVazn-create-form',save_zayeat);
  $("#modal-company").on("submit",'.js-HeatsetMetraj-create-form',save_daf_metraj_heatset_Form);
  $("#tblrows").on('click','.js_daf_metraj_create',open_daf_metraj_modal)
});
