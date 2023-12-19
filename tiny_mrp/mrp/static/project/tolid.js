
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
  $(".btc").on("input", function() {
            var row = $(this).closest("tr");
            var nomre = parseFloat(row.find(".nomre").text()) || parseFloat(row.find(".counter").attr('data-nomre'));
            var counter = parseFloat(row.find(".counter").text()) || 0;
            var formula = row.find("[data-formula]").data("formula");

            var result = evaluateFormula(formula, nomre, counter);
            row.find("[data-formula]").text(result);
        });

        function evaluateFormula(formula, P, Q) {
            formula = formula.replace("P", P).replace("Q", Q);
            try {
              // console.log(formula);
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
        var speed = $(this).attr('data-speed')||0;
        var nomre = $(this).find('td.nomre').text()||$(this).find('td:eq(0)').attr('data-nomre');
        var counter = $(this).find('td.counter').text()||0;
        var production_value =  $(this).find('td.production').text()||0;

        data.push({ machine: machine, shift: shift,dayOfIssue: dayOfIssue, speed: speed,nomre: nomre
          , counter: counter,production_value: production_value
           });
         }
      });
      // console.log(JSON.stringify(data));
      return data;


}
$("#save_production").click(function(){
  var tbl1=tableDataToJSON('tbl1');
  var tbl2=tableDataToJSON('tbl2');
  var tbl3=tableDataToJSON('tbl3');
  var sendData = {
    table1: tbl1,
    table2: tbl2,
    table3: tbl3
  };
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
      console.log('Data sent successfully:', response);
      $(".preloader").hide();
    },
    error: function(xhr, status, error) {
      // Handle any errors that occur during the AJAX request
      console.error('Error sending data:', error);
    }
  });
  // var tbl2=tableDataToJSON('tbl2');
  // var tbl3=tableDataToJSON('tbl3');
});
});
$(function () {
  var save_zayeat=function(){
    form=$(this);
    alert(12);
    // Initialize an empty array to store the data
            const tableData = [];

            // Get all the table rows (tr elements) within the tbody
            const tableRows = document.querySelectorAll('table.tbl-zayeat-vazn tbody tr');

            // Iterate through each table row
            tableRows.forEach(row => {
                // Initialize an object to store the data for this row
                const rowData = {};

                // Get all the cells (td elements) within the current row
                const cells = row.querySelectorAll('td');

                // Iterate through each cell in the row
                cells.forEach(cell => {
                    // Access the content of each cell and store it in the object
                    const dataId = cell.getAttribute('data-id');
                    const cellContent = cell.innerText.trim()||0;
                    const datadate = cell.getAttribute('data-date');
                    
                    tableData.push({'id':dataId,'vazn':cellContent,'date':datadate});
                });

                // Add the rowData object to the tableData array
                
            });
            console.log(tableData);
            // alert(1);
            // $("#js_data").val(JSON.stringify(tableData));
            

            // Output the collected data
            // console.log(tableData);

            // Sending data via POST request (Example using fetch)
            const url = form.attr('action'); // Replace with your actual POST endpoint URL

            $.ajax({
              url: form.attr("action"),
              data: JSON.stringify(tableData),
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
  $('.editable-cell').on('input', function() {
        // Allow only numeric input
        var text = $(this).text();
        $(this).text(text.replace(/[^0-9]/g, ''));
    });
  $("#modal-company").on("submit",'.js-zayeatVazn-create-form',save_zayeat);
});
