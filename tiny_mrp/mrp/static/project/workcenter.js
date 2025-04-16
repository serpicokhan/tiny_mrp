$(function () {
    // Define work centers in JSON format
    workCentersData = [];

    
        var loadForm =function (btn1) {
            var btn=0;
            if($(btn1).attr("type")=="click")
             btn=$(this);
            else {
              btn=btn1;
            }
        
            return $.ajax({
              url: btn.attr("data-url"),
              type: 'get',
              dataType: 'json',
              beforeSend: function () {
                
                $("#newWorkCenterModal").modal("show");
              },
              success: function (data) {
                
        
                $("#newWorkCenterModal .modal-content").html(data.html_workcenter_form);
                $(".select2").select2();
        
        
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
                  $("#newWorkCenterModal").modal("hide");
                  initializeWorkCenters();
       
                   console.log("success");
                }
                else {
       
                  $("#company-table tbody").html(data.html_workcenter_list);
                  $("#modal-company .modal-content").html(data.html_workcenter_form);
                }
              }
            });
            return false;
          };
        // Initialize the application with data from JSON
        initializeWorkCenters();

        // View switcher
        $('.view-switcher button').click(function() {
            const view = $(this).data('view');
            $('.view-switcher button').removeClass('active');
            $(this).addClass('active');
            
            if(view === 'table') {
                $('#tableView').show();
                $('#kanbanView').hide();
            } else {
                $('#tableView').hide();
                $('#kanbanView').show();
            }
        });

        // Filter buttons
        $('#filterButtons button').click(function() {
            $('#filterButtons button').removeClass('active');
            $(this).addClass('active');
            filterWorkCenters();
        });

        // Search functionality
        $('#workCenterSearch').on('input', function() {
            filterWorkCenters();
        });

        // Create new work center
        $('#createWorkCenterBtn').click(function() {
            if($('#workCenterForm')[0].checkValidity()) {
                const newWorkCenter = {
                    id: Date.now(), // Temporary ID
                    code: $('#workCenterCode').val(),
                    name: $('#workCenterName').val(),
                    capacity: $('#workCenterCapacity').val(),
                    active: $('#workCenterActive').is(':checked'),
                    updated: new Date().toISOString().split('T')[0] + ' ' + new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
                };
                
                // Add to our JSON data
                workCentersData.workCenters.unshift(newWorkCenter);
                
                // Refresh views
                refreshWorkCenters();
                
                $('#newWorkCenterModal').modal('hide');
                $('#workCenterForm')[0].reset();
                alert('Work center created successfully!');
            } else {
                $('#workCenterForm')[0].reportValidity();
            }
        });

        // Edit work center
        $(document).on('click', '.edit-workcenter', function() {
            const workCenterId = parseInt($(this).data('id'));
            const workCenter = workCentersData.workCenters.find(wc => wc.id === workCenterId);
            
            if(workCenter) {
                $('#editWorkCenterId').val(workCenter.id);
                $('#editWorkCenterName').val(workCenter.name);
                $('#editWorkCenterCode').val(workCenter.code);
                $('#editWorkCenterCapacity').val(workCenter.capacity);
                $('#editWorkCenterActive').prop('checked', workCenter.active);
                
                $('#editWorkCenterModal').modal('show');
            }
        });

        // Update work center
        $('#updateWorkCenterBtn').click(function() {
            if($('#editWorkCenterForm')[0].checkValidity()) {
                const workCenterId = parseInt($('#editWorkCenterId').val());
                const workCenterIndex = workCentersData.workCenters.findIndex(wc => wc.id === workCenterId);
                
                if(workCenterIndex !== -1) {
                    // Update the work center in our JSON data
                    workCentersData.workCenters[workCenterIndex] = {
                        id: workCenterId,
                        code: $('#editWorkCenterCode').val(),
                        name: $('#editWorkCenterName').val(),
                        capacity: $('#editWorkCenterCapacity').val(),
                        active: $('#editWorkCenterActive').is(':checked'),
                        updated: new Date().toISOString().split('T')[0] + ' ' + new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
                    };
                    
                    // Refresh views
                    refreshWorkCenters();
                    
                    $('#editWorkCenterModal').modal('hide');
                    alert('Work center updated successfully!');
                }
            } else {
                $('#editWorkCenterForm')[0].reportValidity();
            }
        });

        // Toggle work center status
        $(document).on('click', '.toggle-status', function() {
            const workCenterId = parseInt($(this).data('id'));
            const currentStatus = $(this).data('status');
            const newStatus = !currentStatus;
            
            if(confirm(`Are you sure you want to ${newStatus ? 'activate' : 'deactivate'} this work center?`)) {
                const workCenterIndex = workCentersData.workCenters.findIndex(wc => wc.id === workCenterId);
                
                if(workCenterIndex !== -1) {
                    // Update status in our JSON data
                    workCentersData.workCenters[workCenterIndex].active = newStatus;
                    workCentersData.workCenters[workCenterIndex].updated = 
                        new Date().toISOString().split('T')[0] + ' ' + new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
                    
                    // Refresh views
                    refreshWorkCenters();
                    
                    alert(`Work center ${newStatus ? 'activated' : 'deactivated'} successfully!`);
                }
            }
        });

        // Initialize work centers from JSON data
        function initializeWorkCenters() {
            refreshWorkCenters();
        }

        // Refresh both table and kanban views from JSON data
        function refreshWorkCenters() {
            $.ajax({
                url: '/api/workcenter/',  // Your Django endpoint
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    // Process the response data (similar to your mockProducts)
                    // console.log('Received products:', response);
                    $('#workCentersTableBody').empty();
                    $('#kanbanView').empty();
                    workCentersData=response;
                    console.log(response);
                    // Rebuild views from JSON data
                    workCentersData.forEach(workCenter => {
                        addWorkCenterToTable(workCenter);
                        addWorkCenterToKanban(workCenter);
                    });
                    
                    // Reapply any active filters
                    filterWorkCenters();
                   
                },
                error: function(xhr, status, error) {
                    console.error('Error fetching products:', error);
                }
            });
            // Clear existing views
          
        }

        // Helper function to filter work centers
        function filterWorkCenters() {
            const searchTerm = $('#workCenterSearch').val().toLowerCase();
            const activeFilter = $('#filterButtons .btn.active').attr('id');
            
            // Filter table view
            $('#workCentersTableBody tr').each(function() {
                const name = $(this).find('td:nth-child(2)').text().toLowerCase();
                const code = $(this).find('td:nth-child(1)').text().toLowerCase();
                const statusBadge = $(this).find('.status-badge');
                const isActive = statusBadge.hasClass('status-active');
                
                const matchesSearch = name.includes(searchTerm) || code.includes(searchTerm);
                let matchesFilter = true;
                
                if(activeFilter === 'filterActive') {
                    matchesFilter = isActive;
                } else if(activeFilter === 'filterInactive') {
                    matchesFilter = !isActive;
                }
                
                $(this).toggle(matchesSearch && matchesFilter);
            });
            
            // Filter kanban view
            $('.kanban-card').each(function() {
                const name = $(this).find('h5').text().toLowerCase();
                const code = $(this).find('.kanban-card-header strong').text().toLowerCase();
                const statusBadge = $(this).find('.status-badge');
                const isActive = statusBadge.hasClass('status-active');
                
                const matchesSearch = name.includes(searchTerm) || code.includes(searchTerm);
                let matchesFilter = true;
                
                if(activeFilter === 'filterActive') {
                    matchesFilter = isActive;
                } else if(activeFilter === 'filterInactive') {
                    matchesFilter = !isActive;
                }
                
                $(this).closest('.col-xl-3').toggle(matchesSearch && matchesFilter);
            });
        }

        // Helper function to add work center to table
        function addWorkCenterToTable(workCenter) {
            const newRow = `
                <tr>
                    <td><strong>${workCenter.code}</strong></td>
                    <td>${workCenter.name}</td>
                    <td>${workCenter.capacity} units</td>
                    <td><span class="status-badge ${workCenter.active ? 'status-active' : 'status-inactive'}">
                        ${workCenter.active ? 'فعال' : 'غیر فعال'}
                    </span></td>
                    <td>${workCenter.updated}</td>
                    <td>
                        <button class="btn btn-sm btn-outline-primary edit-workcenter" data-id="${workCenter.id}">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm ${workCenter.active ? 'btn-outline-danger' : 'btn-outline-success'} toggle-status" 
                                data-id="${workCenter.id}" data-status="${workCenter.active}">
                            <i class="fas fa-power-off"></i>
                        </button>
                    </td>
                </tr>
            `;
            
            $('#workCentersTableBody').append(newRow);
        }

        // Helper function to add work center to kanban
        function addWorkCenterToKanban(workCenter) {
            const newCard = `
                <div class="col-xl-3 col-lg-4 col-md-6">
                    <div class="kanban-card">
                        <div class="kanban-card-header d-flex justify-content-between align-items-center">
                            <strong>${workCenter.code}</strong>
                            <span class="status-badge ${workCenter.active ? 'status-active' : 'status-inactive'}">
                                ${workCenter.active ? 'فعال' : 'غیرفعال'}
                            </span>
                        </div>
                        <div class="kanban-card-body">
                            <h5>${workCenter.name}</h5>
                            <p class="mb-1"><i class="fas fa-tachometer-alt mr-2"></i> Capacity: ${workCenter.capacity} units/hour</p>
                            <p class="mb-0"><i class="far fa-clock mr-2"></i> Updated: ${workCenter.updated}</p>
                        </div>
                        <div class="kanban-card-footer d-flex justify-content-start">
                            <button class="btn btn-sm btn-outline-primary edit-workcenter" data-id="${workCenter.id}">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm ${workCenter.active ? 'btn-outline-danger' : 'btn-outline-success'} toggle-status ml-2" 
                                    data-id="${workCenter.id}" data-status="${workCenter.active}">
                                <i class="fas fa-power-off"></i>
                            </button>
                        </div>
                    </div>
                </div>
            `;
            
            $('#kanbanView').append(newCard);
        }
    
$(".create-new-workcenter").click(loadForm);
$("#newWorkCenterModal").on("submit", ".js-workcenter-create-form", saveForm);

});