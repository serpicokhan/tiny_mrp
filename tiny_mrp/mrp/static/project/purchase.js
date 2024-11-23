
$(document).ready(function() {
    // Add New Row
    $('#add-row').on('click', function() {
        const newRow = `
            <tr>
                <td contenteditable="true" class="editable-cell part-name" data-id="" data-partcode="">کالای جدید</td>
                <td contenteditable="true" class="editable-cell">0</td>
                <td contenteditable="true" class="editable-cell machine-name" data-id="" data-machinecode="">قسمت مورد استفاده</td>
                <td contenteditable="true" class="editable-cell description" data-id="">شرح</td>
                <td>
                <button class="btn btn-sm  delete-row">
                    <i class="fa fa-trash"></i> <!-- Tiny Trash Icon -->
                </button>
            </td>
            </tr>
        `;
        $('#table-body').append(newRow);
    });

    // API URLs
    const fetchPartsApiUrl = "http://192.168.2.111:8000/WoPart/GetParts"; // Replace with your API endpoint for fetching parts
    const createPartsApiUrl = "https://example.com/api/create-part"; // Replace with your API endpoint for creating parts
    const fetchMachinesApiUrl = "http://192.168.2.111:8000/Asset/GetAssets"; // Replace with your API endpoint for fetching machines
    const createMachinesApiUrl = "https://example.com/api/create-machine"; // Replace with your API endpoint for creating machines

    // Generic function to handle dropdown and search
    function handleSuggestions($cell, apiUrl, createApiUrl, type) {
        $cell.on('input', function() {
            const inputValue = $cell.text().trim();

            if (inputValue.length < 2) {
                // Hide dropdown if input is too short
                $('.dropdown-menu').remove();
                return;
            }

            // Fetch suggestions from API
            $.ajax({
                url: apiUrl,
                method: "GET",
                data: { qry: inputValue },
                success: function(data) {
                    console.log(data);
                    // Create dropdown
                    let dropdownHtml = '<div class="dropdown-menu show">';
                    data.forEach(item => {
                        if(type=="Part"){
                            dropdownHtml += `
                                <button class="dropdown-item" 
                                        data-id="${item.id}" 
                                        data-code="${item.partCode}" 
                                        data-name="${item.partName}">
                                    ${item.partName}
                            </button>`;
                        }
                        else if(type=="Machine"){
                            dropdownHtml += `
                            <button class="dropdown-item" 
                                    data-id="${item.id}" 
                                    data-code="${item.assetCode}" 
                                    data-name="${item.assetName}">
                                ${item.assetName}
                                </button>`;

                        }
                    });

                    // Add "Create New Item" option
                    dropdownHtml += `
                        <button class="dropdown-item create-new" data-typed="${inputValue}">
                            +جدید "${inputValue}"
                        </button>
                    </div>`;

                    // Position dropdown
                    const offset = $cell.offset();
                    const $dropdown = $(dropdownHtml).css({
                        position: 'absolute',
                        top: offset.top + $cell.outerHeight(),
                        left: offset.left,
                        width: $cell.outerWidth(),
                        zIndex: 1000
                    });

                    // Remove existing dropdown and append the new one
                    $('.dropdown-menu').remove();
                    $('body').append($dropdown);

                    // Select item from dropdown
                    $dropdown.on('click', '.dropdown-item:not(.create-new)', function() {
                        const selectedName = $(this).data('name');
                        const selectedId = $(this).data('id');
                        const selectedCode = $(this).data('code');

                        // Update the cell content and data attributes
                        $cell.text(selectedName);
                        $cell.attr('data-id', selectedId);
                        $cell.attr('data-code', selectedCode);

                        // Remove dropdown
                        $dropdown.remove();
                    });

                    // Handle "Create New Item" click
                    $dropdown.on('click', '.create-new', function() {
                        const newName = $(this).data('typed');

                        // Call API to create new item
                        $.ajax({
                            url: createApiUrl,
                            method: "POST",
                            contentType: "application/json",
                            data: JSON.stringify({ name: newName }),
                            success: function(response) {
                                // Assume the response contains the newly created item's details
                                const newItem = response; // Example: { id: 100, code: "new_machine_code", name: "New Machine" }

                                // Update the cell content and data attributes
                                $cell.text(newItem.name);
                                $cell.attr('data-id', newItem.id);
                                $cell.attr('data-code', newItem.code);

                                // Remove dropdown
                                $dropdown.remove();
                            },
                            error: function() {
                                alert(`Error creating new ${type}. Please try again.`);
                            }
                        });
                    });

                    // Remove dropdown on blur
                    $cell.on('blur', function() {
                        setTimeout(() => $dropdown.remove(), 200); // Allow time for click
                    });
                },
                error: function() {
                    console.error(`Error fetching ${type} suggestions`);
                }
            });
        });
    }

    $(document).on('click', '.delete-row', function() {
        const $row = $(this).closest('tr'); // Find the closest <tr> (the row)
        $row.remove(); // Remove the row from the table
    });

    // Attach event for part-name
    $(document).on('focus', '.part-name', function() {
        handleSuggestions($(this), fetchPartsApiUrl, createPartsApiUrl, "Part");
    });

    // Attach event for machine-name
    $(document).on('focus', '.machine-name', function() {
        handleSuggestions($(this), fetchMachinesApiUrl, createMachinesApiUrl, "Machine");
    });
});

