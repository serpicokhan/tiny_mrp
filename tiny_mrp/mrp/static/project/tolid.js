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

$(function () {
  $(".editable-cell").on("input", function() {
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


//$("#company-table").on("click", ".js-update-wo", initxLoad);
});
