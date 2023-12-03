var firstPressedButton = null;
// var isCtrlPressed = false;
// var selectedCells = [];
//
//     $(document).keydown(function(event) {
//       if (event.which === 17) { // 17 is the key code for Control (Ctrl)
//         isCtrlPressed = true;
//       }
//     });
//
//     $(document).keyup(function(event) {
//       if (event.which === 17) { // 17 is the key code for Control (Ctrl)
//         isCtrlPressed = false;
//       }
//     });
//
//         // Event delegation for cell click event
//         $('#company-table').on('click', 'td[contenteditable="true"]', function(event) {
//           if (isCtrlPressed) {
//             $(this).toggleClass('selected');
//
//             var cellValue = $(this).html();
//             var cellIndex = $(this).index();
//             var rowIndex = $(this).closest('tr').index();
//             var cellKey = rowIndex + '-' + cellIndex;
//
//             if ($(this).hasClass('selected')) {
//               selectedCells[cellKey] = cellValue;
//             } else {
//               delete selectedCells[cellKey];
//             }
//           }
//         });
//
//         // Event delegation for cell blur event
//         $('#company-table').on('blur', 'td[contenteditable="true"]', function(event) {
//           if (isCtrlPressed) {
//             var newValue = $(this).html();
//             for (var cellKey in selectedCells) {
//               var cell = $('#' + cellKey);
//               cell.html(newValue);
//             }
//           }
//         });
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
            var nomre = parseFloat(row.find(".nomre").text()) || 0;
            var counter = parseFloat(row.find(".counter").text()) || 0;
            var formula = row.find("[data-formula]").data("formula");

            var result = evaluateFormula(formula, nomre, counter);
            row.find("[data-formula]").text(result);
        });

        function evaluateFormula(formula, P, Q) {
            formula = formula.replace("P", P).replace("Q", Q);
            try {
                var result = eval(formula);
                return result.toFixed(2); // Adjust as needed
            } catch (error) {
                console.error("Error evaluating formula:", error);
                return "Error";
            }
        }
  $(".editable-cell2").on("input", function() {
            var row = $(this).closest("tr");
            var z = parseFloat(row.find(".speed").text()) || 0;
            var p = parseFloat(row.find(".speed").data('nomre')) || 0;
            var formula = row.find("[data-formula]").data("formula");

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
});
