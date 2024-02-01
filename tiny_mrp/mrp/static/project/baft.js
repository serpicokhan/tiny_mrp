
$(function () {

  $('#company-table').on('keypress', 'td[contenteditable="true"]', function(e) {

    // Check if the pressed key is 'Enter'
    if (e.which == 13) {
        e.preventDefault(); // Prevent default Enter behavior

        var table = $('#company-table'); // Your table ID
        var newRow = $('<tr>'); // Create a new row element

        // Get the number of columns from the header
        var cols = table.find('thead th').length;

        // Add the same number of cells to the new row
        for (var i = 0; i < cols; i++) {
            newRow.append('<td contenteditable="true"></td>');
        }

        // Append the new row to the table body
        table.find('tbody').append(newRow);

        // Set focus to the first cell of the new row
        newRow.find('td:first').focus();
    }
});

  });
