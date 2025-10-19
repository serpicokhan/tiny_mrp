$(function () {

    // Global variables
    let currentBomId = null;
    let currentPage = 1;
    const itemsPerPage = 5;
    let currentView = 'table';
    
    let mockProducts = [];
    
    function loadProducts() {
        $.ajax({
            url: '/api/products/',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                mockProducts = response;
                initProductFilter();
            },
            error: function(xhr, status, error) {
                console.error('Error fetching products:', error);
            }
        });
    }
    
    const mockComponents = [
        { id: 201, name: "Component X" },
        { id: 202, name: "Component Y" },
        { id: 203, name: "Component Z" },
        { id: 204, name: "Component A" },
        { id: 205, name: "Component B" },
        { id: 206, name: "Component C" }
    ];
    
    let mockBoms = [];
    
    var loadForm = function (btn1) {
        var btn = 0;
        if($(btn1).attr("type") == "click")
            btn = $(this);
        else {
            btn = btn1;
        }
    
        return $.ajax({
            url: btn.attr("data-url"),
            type: 'get',
            dataType: 'json',
            beforeSend: function () {
                $("#bom-form-modal").modal("show");
            },
            success: function (data) {
                $("#bom-form-modal .modal-content").html(data.html_bom_form);
                $(".select2").select2({dropdownParent: $('#bom-form-modal')});
            }
        });
    };
    
    var loadFormComponent = function (btn1) {
        var btn = 0;
        if($(btn1).attr("type") == "click")
            btn = $(this);
        else {
            btn = btn1;
        }
        
        return $.ajax({
            url: btn.attr("data-url"),
            type: 'get',
            dataType: 'json',
            beforeSend: function () {
                $("#component-form-modal").modal("show");
            },
            success: function (data) {
                $("#component-form-modal .modal-content").html(data.html_bom_component_form);
                $(".select2").select2( {dropdownParent: $('#component-form-modal')});
            }
        });
    };
    
    var saveForm = function () {
        var form = $(this);
    
        $.ajax({
            url: form.attr("action"),
            data: form.serialize(),
            type: form.attr("method"),
            dataType: 'json',
            success: function (data) {
                if (data.form_is_valid) {
                    $("#bom-form-modal").modal("hide");
                    loadBomList();
                    console.log("success");
                } else {
                    $("#bom-form-modal .modal-content").html(data.html_bom_form);
                    $(".select2").select2();
                }
            }
        });
        return false;
    };
    
    var saveComponentForm = function () {
        var form = $("#component-form");
    
        $.ajax({
            url: form.attr("action"),
            data: form.serialize(),
            type: form.attr("method"),
            dataType: 'json',
            success: function (data) {
                if (data.form_is_valid) {
                    $("#component-table-body").html(data.html_component_list);
                    $("#component-form-modal").modal("hide");
                    
                    // به‌روزرسانی تعداد components در جدول اصلی
                    loadBomList();
                } else {
                    $("#component-form-modal .modal-content").html(data.html_bom_component_form);
                    $(".select2").select2();
                }
            }
        });
        return false;
    };
    
    loadProducts();
    loadBomList();
    initComponentForm();
    
    // Event handlers
    $('#create-bom-btn').click(loadForm);
    $('#bom-search').on('keyup', filterBoms);
    $('#product-filter').change(filterBoms);
    
    // View toggle buttons
    $('.view-toggle').click(function() {
        const view = $(this).data('view');
        setView(view);
    });
    
    // Pagination handlers
    $(document).on('click', '.page-link', function(e) {
        e.preventDefault();
        const pageText = $(this).text().toLowerCase();
        
        if (pageText === 'قبلی' && currentPage > 1) {
            currentPage--;
            loadBomList();
        } else if (pageText === 'بعدی') {
            currentPage++;
            loadBomList();
        } else if (!isNaN(pageText)) {
            currentPage = parseInt(pageText);
            loadBomList();
        }
    });
    
    // Set the current view (table or grid)
    function setView(view) {
        currentView = view;
        $('.view-toggle').removeClass('active');
        $(`#${view}-view-btn`).addClass('active');
        
        $('.view-content').hide();
        $(`#${view}-view`).show();
        
        loadBomList();
    }
    
    // Initialize product filter dropdown
    function initProductFilter() {
        const $productFilter = $('#product-filter');
        $productFilter.empty().append('<option value="">فیلتر بر اساس محصول</option>');
        
        mockProducts.forEach(product => {
            $productFilter.append(`<option value="${product.id}">${product.name}</option>`);
        });
    }
    
    // Initialize component form dropdown
    function initComponentForm() {
        const $componentSelect = $('#component-product');
        $componentSelect.empty().append('<option value="">Select a component</option>');
        
        mockComponents.forEach(component => {
            $componentSelect.append(`<option value="${component.id}">${component.name}</option>`);
        });
    }
    
    function loadBomList() {
        $.ajax({
            url: '/api/boms/',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                mockBoms = response;
                const filteredBoms = filterBomData(mockBoms);
                const totalItems = filteredBoms.length; 
                const totalPages = Math.ceil(totalItems / itemsPerPage);
                
                const startIndex = (currentPage - 1) * itemsPerPage;
                const paginatedBoms = filteredBoms.slice(startIndex, startIndex + itemsPerPage);
                
                const startItem = startIndex + 1;
                const endItem = Math.min(startIndex + itemsPerPage, totalItems);
                $('#table-count-info').text(`نمایش ${startItem}-${endItem} از ${totalItems} BOMs`);
                
                updatePagination(totalPages);
                
                if (paginatedBoms.length > 0) {
                    if (currentView === 'table') {
                        renderBomTable(paginatedBoms);
                    } else {
                        renderBomGrid(paginatedBoms);
                    }
                } else {
                    if (currentView === 'table') {
                        $('#empty-bom-table').show();
                        $('#bom-table-body').empty();
                    } else {
                        $('#empty-bom-grid').show();
                        $('#bom-grid').empty();
                    }
                }
            },
            error: function(xhr, status, error) {
                console.error('Error fetching BOMs:', error);
            }
        });
    }
    
    // Filter BOM data based on search and product filter
    function filterBomData(boms) {
        const searchTerm = $('#bom-search').val().toLowerCase();
        const productId = $('#product-filter').val();
        
        return boms.filter(bom => {
            const matchesSearch = searchTerm === '' || 
                bom.reference.toLowerCase().includes(searchTerm) || 
                bom.product.name.toLowerCase().includes(searchTerm);
            
            const matchesProduct = productId === '' || bom.product.id == productId;
            
            return matchesSearch && matchesProduct;
        });
    }
    
    // Update pagination controls
    function updatePagination(totalPages) {
        const paginationHtml = generatePaginationHtml(totalPages);
        $('#table-pagination').html(paginationHtml);
        $('#grid-pagination').html(paginationHtml);
    }
    
    // Generate pagination HTML
    function generatePaginationHtml(totalPages) {
        let html = `
            <li class="page-item ${currentPage === 1 ? 'disabled' : ''}">
                <a class="page-link" href="#" tabindex="-1">قبلی</a>
            </li>
        `;
        
        for (let i = 1; i <= totalPages; i++) {
            html += `
                <li class="page-item ${currentPage === i ? 'active' : ''}">
                    <a class="page-link" href="#">${i}</a>
                </li>
            `;
        }
        
        html += `
            <li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
                <a class="page-link" href="#">بعدی</a>
            </li>
        `;
        
        return html;
    }
    
    // Render BOM table view
    function renderBomTable(boms) {
        $('#empty-bom-table').hide();
        $('#bom-table-body').empty();
        
        boms.forEach(bom => {
            const bomRow = $(`
                <tr data-bom-id="${bom.id}">
                    <td><strong>${bom.reference}</strong></td>
                    <td>${bom.product.name}</td>
                    <td>${bom.components.length} مولفه‌ای</td>
                    <td>${bom.operation_time} دقیقه</td>
                    <td>${formatDate(bom.updated_at)}</td>
                    <td>
                        <button class="btn btn-sm btn-outline-primary view-bom-btn" data-bom-id="${bom.id}">
                            <i class="fas fa-eye"></i> 
                        </button>
                        <button class="btn btn-sm btn-outline-secondary edit-bom-btn" data-bom-id="${bom.id}">
                            <i class="fas fa-edit"></i>
                        </button>
                    </td>
                </tr>
            `);
            
            bomRow.find('.view-bom-btn').click(function() {
                loadBomDetails(bom.id);
                $('#bom-detail-modal').modal('show');
            });
            
            bomRow.find('.edit-bom-btn').click(function() {
                showEditBomModal(bom.id);
            });
            
            $('#bom-table-body').append(bomRow);
        });
    }
    
    // Render BOM grid view
    function renderBomGrid(boms) {
        $('#empty-bom-grid').hide();
        $('#bom-grid').empty();
        
        boms.forEach(bom => {
            const bomCard = $(`
                <div class="card bom-card" data-bom-id="${bom.id}">
                    <div class="card-header bg-primary">
                        <h5 class="card-title mb-0">${bom.reference}</h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text"><strong>محصول:</strong> ${bom.product.name}</p>
                        <p class="card-text"><strong>اجزا:</strong> ${bom.components.length}</p>
                        <p class="card-text"><strong>زمان عملیاتی:</strong> ${bom.operation_time} دقیقه</p>
                        <p class="card-text"><small class="text-muted">آخرین بروز رسانی: ${formatDate(bom.updated_at)}</small></p>
                    </div>
                    <div class="card-footer bg-transparent">
                        <button class="btn btn-sm btn-outline-primary view-bom-btn" data-bom-id="${bom.id}">
                            <i class="fas fa-eye"></i> 
                        </button>
                        <button class="btn btn-sm btn-outline-secondary edit-bom-btn" data-bom-id="${bom.id}">
                            <i class="fas fa-edit"></i> 
                        </button>
                    </div>
                </div>
            `);
            
            bomCard.find('.view-bom-btn').click(function() {
                loadBomDetails(bom.id);
                $('#bom-detail-modal').modal('show');
            });
            
            bomCard.find('.edit-bom-btn').click(function() {
                showEditBomModal(bom.id);
            });
            
            $('#bom-grid').append(bomCard);
        });
    }
    
    // Load BOM details
    function loadBomDetails(bomId) {
        currentBomId = bomId;
        
        $.ajax({
            url: `/BOM/${bomId}/view`,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                $("#bom-detail-modal .modal-content").html(response.html_bom_view_form);
            },
            error: function(xhr, status, error) {
                console.error('Error fetching BOM details:', error);
            }
        });
    }
    
    // Show edit BOM modal - اصلاح شده
    function showEditBomModal(bomId) {
        if (!bomId) return;
        
        // درخواست AJAX برای بارگذاری فرم ویرایش
        $.ajax({
            url: `/BOM/${bomId}/edit`,  // URL جدید برای ویرایش
            type: 'GET',
            dataType: 'json',
            beforeSend: function () {
                $("#bom-form-modal").modal("show");
            },
            success: function (data) {
                $("#bom-form-modal .modal-content").html(data.html_bom_form);
                $(".select2").select2({
                    dropdownParent: $('#bom-form-modal')
                });
            },
            error: function(xhr, status, error) {
                console.error('Error loading edit form:', error);
                alert('خطا در بارگذاری فرم ویرایش');
            }
        });
    }
    
    // حذف component - تابع جدید
    var removeComponent = function() {
        if (!confirm('از عمل حذف این مولفه مطمین هستید؟')) {
            return false;
        }
        
        var componentId = $(this).data('component-id');
        var componentRow = $(this).closest('tr');
        
        $.ajax({
            url: `/BOM/component/${componentId}/delete`,
            type: 'POST',
            data: {
                'csrfmiddlewaretoken': $('[name=csrfmiddlewaretoken]').val()
            },
            dataType: 'json',
            success: function(data) {
                if (data.form_is_valid) {
                    $("#component-table-body").html(data.html_component_list);
                    
                    // به‌روزرسانی تعداد components در جدول اصلی
                    loadBomList();
                } else {
                    alert('خطا در حذف: ' + (data.error || 'خطای ناشناخته'));
                }
            },
            error: function(xhr, status, error) {
                console.error('Error deleting component:', error);
                alert('خطا در حذف مولفه');
            }
        });
        
        return false;
    };
    
    // Filter BOMs
    function filterBoms() {
        currentPage = 1;
        loadBomList();
    }
    
    // Helper function to format date
    function formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
    }
    
    // Helper function to show toast messages
    function showToast(message, type = 'success') {
        alert(`${type.toUpperCase()}: ${message}`);
    }
    
    // Event bindings
    $("#bom-form-modal").on("submit", ".js-bom-create-form", saveForm);
    $("#component-form-modal").on("click", "#save-component-btn", saveComponentForm);
    $(document).on("click", ".add-component-btn", loadFormComponent);
    $(document).on("click", ".remove-component-btn", removeComponent);
    
    });