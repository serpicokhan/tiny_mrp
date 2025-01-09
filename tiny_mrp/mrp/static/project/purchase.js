
$(document).ready(function() {
    // Add New Row
    $(document).on('click','#add-row', function() {
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
    const fetchPartsApiUrl = "/WoPart/GetParts"; // Replace with your API endpoint for fetching parts
    const createPartsApiUrl = "/api/create-part/"; // Replace with your API endpoint for creating parts
    const fetchMachinesApiUrl = "/Asset/GetAssets"; // Replace with your API endpoint for fetching machines
    const createMachinesApiUrl = "/api/create-asset/"; // Replace with your API endpoint for creating machines
    var createApiUrl='';
    $(document).on('click', '.dropdown-item:not(.create-new)', function() {
        // alert("123");
        const $dropdown = $(this).closest('.dropdown-menu');
        const $cell = $('[data-active="true"]'); // Assuming you mark the active cell
        
        if ($cell.length) {
            
        const selectedName = $(this).data('name');

        const selectedId = $(this).data('id');

        const selectedCode = $(this).data('code');

        // Update the cell content and data attributes
        $cell.text(selectedName);
        $cell.attr('data-id', selectedId);
        $cell.attr('data-code', selectedCode);

        // Remove dropdown
        $dropdown.remove();
        $cell.removeAttr('data-active');
        }
    });
    $(document).on('click', '.create-new', function() {
        const newName = $(this).data('typed');
        const $dropdown = $(this).closest('.dropdown-menu');

        const $cell = $('[data-active="true"]'); // Assuming you mark the active cell
        console.log(createApiUrl);


        // Call API to create new item
        $.ajax({
            url: createApiUrl,
            method: "post",
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

    // Generic function to handle dropdown and search
    function handleSuggestions($cell, apiUrl, createApiUrl2, type) {
        createApiUrl=createApiUrl2;
        $cell.on('input', function() {
            const inputValue = $cell.text().trim();

            if (inputValue.length < 2) {
                // Hide dropdown if input is too short
                // $cell.removeAttr('data-active'); // Clear active state
                $('.dropdown-menu').remove();
                return;
            }

            // Fetch suggestions from API
            $.ajax({
                url: apiUrl,
                method: "GET",
                data: { qry: inputValue },
                success: function(data) {
                    // console.log(data);
                    // Create dropdown
                    let dropdownHtml = '<div class="dropdown-menu show">';
                    data.forEach(item => {
                        if(type=="Part"){
                            // console.log(item);
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
                        left: offset.left-100,
                        width: $cell.outerWidth(),
                        zIndex: 1000
                    });

                    // Remove existing dropdown and append the new one
                    $('.dropdown-menu').remove();
                    $('body').append($dropdown);

                    // Select item from dropdown
                    
                    // Handle "Create New Item" click
                    let $items = $dropdown.find('.dropdown-item');
                    let currentIndex = -1;
    
                    // Keyboard navigation
                    $cell.off('keydown').on('keydown', function (e) {
                        if (e.key === 'ArrowDown') {
                            e.preventDefault();
                            currentIndex = (currentIndex + 1) % $items.length;
                            $items.removeClass('active');
                            $items.eq(currentIndex).addClass('active');
                        } else if (e.key === 'ArrowUp') {
                            e.preventDefault();
                            currentIndex = (currentIndex - 1 + $items.length) % $items.length;
                            $items.removeClass('active');
                            $items.eq(currentIndex).addClass('active');
                        } else if (e.key === 'Enter') {
                            e.preventDefault();
                            if (currentIndex >= 0) {
                                $items.eq(currentIndex).trigger('click');
                            }
                        }
                    });
    
                    // Select item on click
                    $dropdown.on('click', '.dropdown-item', function () {
                        const selectedValue = $(this).data('name');
                        $cell.text(selectedValue).trigger('change'); // Update cell text and trigger change
                        $dropdown.remove(); // Remove dropdown
                    });

                    // Remove dropdown on blur
                    $cell.on('blur', function() {
                        // $cell.removeAttr('data-active');
                        setTimeout(() => $dropdown.remove(), 400); // Allow time for click
                    });
                },
                error: function() {
                    console.error(`Error fetching ${type} suggestions`);
                }
            });
        });
    }
    // $(document).on('click', '.create-new-item', function() {
    //     alert("123");
    // });

    $(document).on('click', '.delete-row', function() {
        const $row = $(this).closest('tr'); // Find the closest <tr> (the row)
        $row.remove(); // Remove the row from the table
    });

    // Attach event for part-name
    $(document).on('focus', '.part-name', function() {
        const $cell = $(this);
        $('[data-active="true"]').removeAttr('data-active');

        // Mark the current cell as active
        $cell.attr('data-active', 'true');
        handleSuggestions($cell, fetchPartsApiUrl, createPartsApiUrl, "Part");
    });

    // Attach event for machine-name
    $(document).on('focus', '.machine-name', function() {
        const $cell = $(this);
        $('[data-active="true"]').removeAttr('data-active');

        // Mark the current cell as active
        $cell.attr('data-active', 'true');
        handleSuggestions($cell, fetchMachinesApiUrl, createMachinesApiUrl, "Machine");
    });
    $(document).on('focus','.editable-cell', function() {
        var cell = this;
        
        // Highlight the text inside the cell
        $(cell).css('background-color', '#ffffcc'); // Light yellow background
        
        // Create a range and select the text
        var range = document.createRange();
        var selection = window.getSelection();
        range.selectNodeContents(cell); // Selects all text content of the cell
        selection.removeAllRanges(); // Removes any previous selection
        selection.addRange(range); // Adds the new range (selection)
    });

    $(document).on('blur','.editable-cell', function() {
        // Reset background color
        $(this).css('background-color', '');
    });
    $(document).on("click",'#saveButton', function () {
        let requestData = [];
        let valid = true;  // Flag to check if all fields are valid
        let errorMessage = '';
        let main_data=[];
        let companyId=$("#companyId").val()||null;
        let user_name=$("#requested_user").val()||null;
        

        // Iterate through each table row
        $("#table-body tr").each(function () {
            const partNameCell = $(this).find(".part-name");
            const quantityCell = $(this).find(".editable-cell").eq(1); // Second cell for quantity
            const machineNameCell = $(this).find(".machine-name");
            const descriptionCell = $(this).find(".description");
            const item_id=$(this).attr("data-id")||null;

            // Validate fields
            if (!partNameCell.text().trim()) {
                valid = false;
                errorMessage += "اسم قطعه ضروری است.\n";
            }
            if (!partNameCell.attr("data-id")) {
                valid = false;
                errorMessage += "کد قطعه ضرور است.\n";
            }

            if (!quantityCell.text().trim() || isNaN(quantityCell.text().trim()) || parseInt(quantityCell.text().trim()) <= 0) {
                valid = false;
                errorMessage += "تعداد بایستی عدد مثبت باشد.\n";
            }

            if (!machineNameCell.attr("data-id")) {
                valid = false;
                errorMessage += "کد ماشین ضروری است.\n";
            }

            if (!descriptionCell.text().trim()) {
                valid = false;
                errorMessage += "شرح ضروری است.\n";
            }
           console.log({
            id:item_id,
            part_name: partNameCell.text().trim(),
            part_code: partNameCell.attr("data-id") || null,
            quantity: parseInt(quantityCell.text().trim()) || 0,
            machine_name: machineNameCell.text().trim(),
            machine_code: machineNameCell.attr("data-id") || null,
            description: descriptionCell.text().trim(),
        });
           
            // console.log(partNameCell,quantityCell,machineNameCell,machineCodeCell,descriptionCell);

            // If all fields are valid, push the data
            if (valid) {
                requestData.push({
                    id:item_id,
                    part_name: partNameCell.text().trim(),
                    part_code: partNameCell.attr("data-id") || null,
                    quantity: parseInt(quantityCell.text().trim()) || 0,
                    machine_name: machineNameCell.text().trim(),
                    machine_code: machineNameCell.attr("data-id") || null,
                    description: descriptionCell.text().trim(),
                });
            }
        });
        main_data.push({id:companyId,user_name:user_name,items:requestData})

        // If any invalid field, show error and prevent sending
        if (!valid) {
          
            swal("لطفا مقادیر زیر را با دقت وارد نمایید:\n\n" + errorMessage);
            errorMessage='';
            return;  // Stop the form submission
        }
        var last_id="0"
        // Send the data to the backend via AJAX
        $.ajax({
            url: "/api/save-purchase-request/",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({id:companyId,user_name:user_name,items:requestData}),
            beforeSend:function(x){
                console.log( JSON.stringify({id:companyId,user_name:user_name,items:requestData}));
                // x.abort();
            },
            success: function (response) {
                toastr.success("درخواست با موفقیت ثبت شد");
                $('.app-detail').removeClass('show');
                $("#main_ul").html('');
                $("#main_ul").html(response.parchase_req_html);
                last_id=response.purchase_request;
                

                //#################
                const form=$("#image-upload-form")[0];
                const formData = new FormData(form);
                console.log(last_id);
              // Send the FormData to the server using AJAX
              $.ajax({
                url: '/Purchases/UploadImage/?p_id='+last_id,  // Replace with your server-side upload URL
                type: 'POST',
                data: formData,
                processData: false,  // Prevent jQuery from processing the data
                contentType: false,  // Don't set content type header as it will be set by the browser
                success: function (response) {
                  console.log('Upload success', response);
                  alert('فرم ارسال شد!');
                },
                error: function (error) {
                  console.error('Error uploading images:', error);
                  alert('خطا در ارسال فرم');
                }
              });

                //#################

                return false;
            },
            error: function (error) {
                toastr.error("خطا در ثبت درخواست");
                console.log(error);
            }
        });
     
    });
});

