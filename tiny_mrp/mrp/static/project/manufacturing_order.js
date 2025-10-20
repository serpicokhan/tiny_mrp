$(function () {
// Sample JSON data
let  manufacturingOrders = [];
let products = [
    // { id: 1, name: "Office Desk", code: "OD-1001", image: "/media/products/office-desk.jpg" },
    // { id: 2, name: "Office Chair", code: "OC-2001", image: "/media/products/office-chair.jpg" },
    // { id: 3, name: "Bookshelf", code: "BS-3001", image: "/media/products/bookshelf.jpg" },
    // { id: 4, name: "Coffee Table", code: "CT-4001", image: "/media/products/coffee-table.jpg" }
];

let boms = [
    // { id: 1, name: "BOM-OD-1001", productId: 1, description: "Office Desk" },
    // { id: 2, name: "BOM-OC-2001", productId: 2, description: "Office Chair" },
    // { id: 3, name: "BOM-BS-3001", productId: 3, description: "Bookshelf" },
    // { id: 4, name: "BOM-CT-4001", productId: 4, description: "Coffee Table" }
];

const bomComponents = [
    { 
        bomId: 1, 
        components: [
            { name: 'Wood Plank (120cm)', qty: 2, uom: 'Units', available: 25 },
            { name: 'Metal Bracket', qty: 4, uom: 'Units', available: 60 },
            { name: 'Wood Screw 3x40mm', qty: 12, uom: 'Units', available: 200 }
        ]
    },
    { 
        bomId: 2, 
        components: [
            { name: 'Plastic Seat', qty: 1, uom: 'Units', available: 15 },
            { name: 'Metal Legs', qty: 4, uom: 'Units', available: 40 },
            { name: 'Wheels', qty: 5, uom: 'Units', available: 35 }
        ]
    },
    { 
        bomId: 3, 
        components: [
            { name: 'Wood Panel (60x180cm)', qty: 3, uom: 'Units', available: 12 },
            { name: 'Shelf Bracket', qty: 8, uom: 'Units', available: 45 },
            { name: 'Wood Screw 3x30mm', qty: 24, uom: 'Units', available: 180 }
        ]
    },
    { 
        bomId: 4, 
        components: [
            { name: 'Glass Top (80x80cm)', qty: 1, uom: 'Units', available: 8 },
            { name: 'Metal Frame', qty: 1, uom: 'Units', available: 10 },
            { name: 'Rubber Feet', qty: 4, uom: 'Units', available: 32 }
        ]
    }
];

const responsibles = [
    { id: 1, name: "John Doe" },
    { id: 2, name: "Jane Smith" },
    { id: 3, name: "Mike Johnson" },
    { id: 4, name: "Sarah Williams" }
];

customers = [
    // { id: 1, name: "Acme Corp" },
    // { id: 2, name: "Beta Industries" },
    // { id: 3, name: "Gamma Retail" },
    // { id: 4, name: "Delta Enterprises" }
];

const workCenters = [
    { id: 1, name: "Assembly Line 1" },
    { id: 2, name: "Assembly Line 2" },
    { id: 3, name: "Finishing Station" },
    { id: 4, name: "Packaging" }
];

let workOrderList = [];
let componentChart = null;


    // Load data into views
    load_morders();
    loadProducts();
    load_boms();
    loadCustomers();

   
    
    // Load dropdown options
    // loadProductOptions();
    loadCustomerOptions();
    loadResponsibleOptions();
    
    // View toggle buttons
    $('#tableViewBtn').click(function() {
        $('#tableView').show();
        $('#gridView').hide();
        $(this).addClass('active');
        $('#gridViewBtn').removeClass('active');
    });
    
    $('#gridViewBtn').click(function() {
        $('#tableView').hide();
        $('#gridView').show();
        $(this).addClass('active');
        $('#tableViewBtn').removeClass('active');
    });
    
    // Filter buttons (table view)
    $('.filter-buttons .btn').click(function() {
        $('.filter-buttons .btn').removeClass('active');
        $(this).addClass('active');
        const filter = $(this).data('filter');
        filterTableOrders(filter);
    });
    
    // Filter buttons (grid view)
    $('[data-grid-filter]').click(function() {
        $('[data-grid-filter]').removeClass('active');
        $(this).addClass('active');
        const filter = $(this).data('grid-filter');
        filterGridOrders(filter);
    });
    
    // Search functionality
    $('#searchBtn').click(function() {
        const searchTerm = $('#searchInput').val().toLowerCase();
        filterTableOrders('all', searchTerm);
        filterGridOrders('all', searchTerm);
    });
    
    $('#searchInput').keypress(function(e) {
        if(e.which === 13) {
            $('#searchBtn').click();
        }
    });

    function load_morders(){
        // Fetch data from the API
        fetch('/api/MOrder/')
            .then(response => response.json())
            .then(data => {
                manufacturingOrders = data.manufacturingOrders;
                loadOrdersTable();
                loadGridView();
                // Use the data as needed
            })
            .catch(error => console.error('Error fetching data:', error));
    }

    // Function to update forecast button state
    function updateForecastButtonState() {
        const productId = $('#productSelect').val();
        const bomId = $('#bomSelect').val();
        const quantity = parseFloat($('#quantityInput').val());
        const isValid = productId && bomId && quantity > 0;
        $('#forecastBtn').prop('disabled', !isValid);
    }

    // Product select change - update BOM options
    $('#newOrderModal').on('change','#productSelect',function() {
        const productId = $(this).val();
        loadBomOptions(productId);
        $('#bomSelect').val('');
        $('#bomPreviewBody').html(`
            <tr>
                <td colspan="4" class="text-center text-muted">Select a product and BOM to see components</td>
            </tr>
        `);
        updateForecastButtonState();
    });
// Product select change - update BOM options
    $('#newOrderModal').on('change','#id_product_to_manufacture',function() {
        const productId = $(this).val();
        loadBomOptions2(productId);
        $('#id_bom').val('');
        $('#bomPreviewBody').html(`
            <tr>
                <td colspan="4" class="text-center text-muted">Select a product and BOM to see components</td>
            </tr>
        `);
        updateForecastButtonState();
    });
    // BOM select change - update component preview
    $('#newOrderModal').on('change','#bomSelect,#id_bom',function() {
        const bomId = $(this).val();
        if(bomId) {
            $('#bomPreviewBody').html(`
                <tr>
                    <td colspan="4" class="text-center">
                        <div class="spinner-border spinner-border-sm" role="status">
                            <span class="visually-hidden"></span>
                        </div>
                        Loading BOM components...
                    </td>
                </tr>
            `);
            setTimeout(function() {
                updateBomPreview(bomId);
            }, 800);
        } else {
            $('#bomPreviewBody').html(`
                <tr>
                    <td colspan="4" class="text-center text-muted">Select a BOM to see components</td>
                </tr>
            `);
        }
        updateForecastButtonState();
    });

    // Quantity change - update BOM preview and button state
    $('#newOrderModal').on('input change','#quantityInput', function() {
        const bomId = $('#bomSelect').val()||$('#id_bom').val();
        if(bomId) {
            updateBomPreview(bomId);
        }
        updateForecastButtonState();
    });

    // Add Work Order button
    $('#newOrderModal').on('click','#addWorkOrderBtn',function() {
        const workOrderId = `WO-2023-${(workOrderList.length + 1).toString().padStart(3, '0')}`;
        workOrderList.push({
            id: workOrderId,
            workCenter: workCenters[0].name,
            duration: 1.0,
            description: ""
        });
        updateWorkOrderTable();
    });

    // Delete Work Order
    $(document).on('click', '.delete-work-order', function() {
        const index = $(this).data('index');
        workOrderList.splice(index, 1);
        updateWorkOrderTable();
    });

    // Update Work Order
    $(document).on('change', '.work-order-select, .duration-input, .description-input', function() {
        const index = $(this).data('index');
        const field = $(this).data('field');
        workOrderList[index][field] = $(this).val();
    });

    // Create MO button
    $('#createMoBtn').click(function() {
        if($('#moForm')[0].checkValidity()) {
            // Create new order object
            const newOrder = {
                id: manufacturingOrders.length + 1,
                reference: "MO/2023/" + (manufacturingOrders.length + 1).toString().padStart(4, '0'),
                product: products.find(p => p.id == $('#productSelect').val()),
                quantity: parseFloat($('#quantityInput').val()),
                bom: $('#bomSelect option:selected').text(),
                workOrders: [...workOrderList],
                status: "draft",
                scheduledDate: $('#dateInput').val().split('T')[0],
                customer: customers.find(c => c.id == $('#customerSelect').val()) || null,
                responsible: responsibles.find(r => r.id == $('#responsibleSelect').val()) || null,
                notes: $('#notesTextarea').val()
            };
            
            // Add to orders array
            manufacturingOrders.unshift(newOrder);
            
            // Reset work order list
            workOrderList = [];
            
            // Refresh views
            loadOrdersTable();
            loadGridView();
            updateWorkOrderTable();
            
            // Close modal and reset form
            alert('Manufacturing order created successfully!');
            $('#newOrderModal').modal('hide');
            $('#moForm')[0].reset();
            $('#bomPreviewBody').html(`
                <tr>
                    <td colspan="4" class="text-center text-muted">Select a product and BOM to see components</td>
                </tr>
            `);
        } else {
            $('#moForm')[0].reportValidity();
        }
    });

    // Reset form when modal is closed
    $('#newOrderModal').on('hidden.bs.modal', function() {
        $('#moForm')[0].reset();
        workOrderList = [];
        updateWorkOrderTable();
        $('#bomPreviewBody').html(`
            <tr>
                <td colspan="4" class="text-center text-muted">Select a product and BOM to see components</td>
            </tr>
        `);
        $('#forecastBtn').prop('disabled', true);
    });

    // Forecast button click with validation
    $('#newOrderModal').on('click', '#forecastBtn', function() {
        console.log('Forecast button clicked');
        const productId = $('#productSelect').val() || $('#id_product_to_manufacture').val();
        const bomId = $('#bomSelect').val() || $('#id_bom').val();
        const quantity = parseFloat($('#quantityInput').val() || $('#id_quantity_to_produce').val());
    
        if (!productId) {
            alert('لطفا یک محصول انتخاب کنید.');
            return;
        }
        if (!bomId) {
            alert('لطفا لیست مواد اولیه (BOM) را انتخاب کنید.');
            return;
        }
        if (!quantity || quantity <= 0) {
            alert('لطفا مقدار معتبری بزرگتر از صفر وارد کنید.');
            return;
        }
    
        console.log('Showing forecast for Product ID:', productId, 'BOM ID:', bomId, 'Quantity:', quantity);
        showForecast(bomId, quantity);
        $('#forecastModal').modal('show');
    });


// Function to load orders into the table
function loadOrdersTable() {
    const tbody = $('#ordersTableBody');
    tbody.empty();
    
    manufacturingOrders.forEach(order => {
        const statusClass = `status-${order.status}`;
        let statusText = '';
        
        switch(order.status) {
            case 'draft': statusText = 'Draft'; break;
            case 'confirmed': statusText = 'Confirmed'; break;
            case 'progress': statusText = 'In Progress'; break;
            case 'done': statusText = 'Done'; break;
            case 'canceled': statusText = 'Canceled'; break;
        }
        
        const workOrderText = order.workOrders.length > 0 ? order.workOrders.map(wo => wo.id).join(', ') : '-';
        
        const row = `
            <tr data-id="${order.id}" data-status="${order.status}">
                <td><strong>${order.reference}</strong></td>
                <td>
                    <img src="${order.product.image}" class="product-image me-2">
                    ${order.product.name} (${order.product.code})
                </td>
                <td>${order.quantity.toFixed(1)}</td>
                <td>${order.bom}</td>
                <td>${workOrderText}</td>
                <td><span class="status-badge ${statusClass}">${statusText}</span></td>
                <td>${order.scheduledDate}</td>
                <td>${order.customer ? order.customer.name : '-'}</td>
                <td>${order.responsible ? order.responsible.name : '-'}</td>
                <td>
                    <a class="btn btn-sm btn-outline-primary me-1" href="/MOrder/${order.id}" target='_blank' title="View">
                        <i class="fas fa-eye"></i>
                    </a>
                    <button class="btn btn-sm btn-outline-secondary js-morder-edit" title="Edit" data-url="/MOrder/${order.id}/Update">
                        <i class="fas fa-edit"></i>
                    </button>
                </td>
            </tr>
        `;
        
        tbody.append(row);
    });
}

// Function to load grid view
function loadGridView() {
    const container = $('#gridContainer');
    container.empty();
    
    manufacturingOrders.forEach(order => {
        const statusClass = `status-${order.status}`;
        let statusText = '';
        
        switch(order.status) {
            case 'draft': statusText = 'Draft'; break;
            case 'confirmed': statusText = 'Confirmed'; break;
            case 'progress': statusText = 'In Progress'; break;
            case 'done': statusText = 'Done'; break;
            case 'canceled': statusText = 'Canceled'; break;
        }
        
        const workOrderText = order.workOrders.length > 0 ? order.workOrders.map(wo => wo.id).join(', ') : 'None';
        
        const card = `
            <div class="grid-card" data-id="${order.id}" data-status="${order.status}">
                <div class="grid-card-title">${order.reference}</div>
                <div class="d-flex align-items-center mb-3">
                    <img src="https://sp-ao.shortpixel.ai/client/to_webp,q_glossy,ret_img/https://tabseer.co/wp-content/uploads/2021/02/Articles-1593028629.png" class="product-image me-2">
                    <div>${order.product.name} (${order.product.code})</div>
                </div>
                <div class="grid-card-details">
                    <div><strong>حجم:</strong> ${order.quantity.toFixed(1)}</div>
                    <div><strong>لیست مواد:</strong> ${order.bom}</div>
                    <div><strong>دستور تولید:</strong> ${workOrderText}</div>
                    <div><strong>تاریخ تولید:</strong> ${order.scheduledDate}</div>
                    <div><strong>مشتری:</strong> ${order.customer ? order.customer.name : 'None'}</div>
                    <div><strong>مسئول:</strong> ${order.responsible ? order.responsible.name : 'None'}</div>
                    <div class="mt-3"><span class="status-badge ${statusClass}">${statusText}</span></div>
                </div>
                <div class="d-flex justify-content-end mt-3">
                    <button class="btn btn-sm btn-outline-primary me-1" title="View">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-secondary" title="Edit">
                        <i class="fas fa-edit"></i>
                    </button>
                </div>
            </div>
        `;
        
        container.append(card);
    });
}

// Function to filter table orders
function filterTableOrders(statusFilter, searchTerm = '') {
    if (statusFilter === 'all' && !searchTerm) {
        $('tr[data-id]').show();
        return;
    }
    
    $('tr[data-id]').each(function() {
        const $row = $(this);
        const rowStatus = $row.data('status');
        const rowText = $row.text().toLowerCase();
        
        const statusMatch = statusFilter === 'all' || rowStatus === statusFilter;
        const searchMatch = !searchTerm || rowText.includes(searchTerm);
        
        if (statusMatch && searchMatch) {
            $row.show();
        } else {
            $row.hide();
        }
    });
}

// Function to filter grid orders
function filterGridOrders(statusFilter, searchTerm = '') {
    if (statusFilter === 'all' && !searchTerm) {
        $('.grid-card').show();
        return;
    }
    
    $('.grid-card').each(function() {
        const $card = $(this);
        const cardStatus = $card.data('status');
        const cardText = $card.text().toLowerCase();
        
        const statusMatch = statusFilter === 'all' || cardStatus === statusFilter;
        const searchMatch = !searchTerm || cardText.includes(searchTerm);
        
        if (statusMatch && searchMatch) {
            $card.show();
        } else {
            $card.hide();
        }
    });
}

// Function to load product options
function loadProducts() {
    $.ajax({
        url: '/api/products/?type=finished',  // Your Django endpoint
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            // Process the response data (similar to your mockProducts)
            // console.log('Received products:', response);
            // Example: Display products in a table
            
            
            if (response.length > 0) {
                products=response;
                
               
                
            } else {
               
            }
        },
        error: function(xhr, status, error) {
            console.error('Error fetching products:', error);
        }
    });

}
function loadCustomers() {
    $.ajax({
        url: '/api/customers/',  // Your Django endpoint
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            // Process the response data (similar to your mockProducts)
            // console.log('Received products:', response);
            // Example: Display products in a table
            
            
            if (response.length > 0) {
                customers=response;
                
               
                
            } else {
               
            }
        },
        error: function(xhr, status, error) {
            console.error('Error fetching products:', error);
        }
    });

}
function loadProductOptions() {
    const select = $('#productSelect');
    select.empty();
    select.append('<option value="" selected disabled>انتخاب محصول</option>');
    
    
    products.forEach(product => {
        select.append(`<option value="${product.id}">${product.name} (${product.code})</option>`);
    });

}

// Function to load customer options
function loadCustomerOptions() {
    const select = $('#customerSelect');
    select.empty();
    select.append('<option value="" selected>No customer</option>');
    
    customers.forEach(customer => {
        select.append(`<option value="${customer.id}">${customer.name}</option>`);
    });
}

// Function to load responsible options
function loadResponsibleOptions() {
    $.ajax({
        url: '/api/responsible-persons/',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            var $responsibleSelect = $('#responsibleSelect');
            $responsibleSelect.empty();
            $responsibleSelect.append('<option value="" selected>No responsible</option>');
            
            $.each(data.responsible_persons, function(index, person) {
                $responsibleSelect.append(
                    $('<option>').val(person.id).text(person.fullName)
                );
            });
        },
        error: function(xhr, status, error) {
            console.error('Error fetching responsible persons:', error);
        }
    });
}

// Function to load BOM options based on product
function load_boms(productId) {
    $.ajax({
        url: `/api/boms`,  // Your Django endpoint
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            // Process the response data (similar to your mockProducts)
            // console.log('Received products:', response);
            // Example: Display products in a table
            if (response.length > 0) {
                
                
                
                boms =response; 
                // boms.filter(bom => bom.productId == productId);
                
                

            } else {
            }
        },
        error: function(xhr, status, error) {
            console.error('Error fetching products:', error);
        }
    });
    
}
// Function to load BOM options based on product
function loadBomOptions(productId) {
    const select = $('#bomSelect');
    select.empty();
    select.append('<option value="" selected disabled>Select a BOM</option>');
    
    if (!productId) return;
    const productBoms = boms.filter(bom => bom.product.id == productId);
    
    if (productBoms.length === 0) {
        select.append('<option value="" disabled>No BOMs available for this product</option>');
    } else {
        productBoms.forEach(bom => {
            select.append(`<option value="${bom.id}">${bom.reference} - ${bom.product}</option>`);
        });
     }
    
}
function loadBomOptions2(productId) {
    const select = $('#id_bom');
    select.empty();
    select.append('<option value="" selected disabled>Select a BOM</option>');
    
    if (!productId) return;
    const productBoms = boms.filter(bom => bom.product.id == productId);
    
    if (productBoms.length === 0) {
        select.append('<option value="" disabled>No BOMs available for this product</option>');
    } else {
        productBoms.forEach(bom => {
            select.append(`<option value="${bom.id}">${bom.reference} - ${bom.product}</option>`);
        });
     }
    
}
// نسخه پیشرفته‌تر با مدیریت بهتر خطا و پارامترهای قابل تنظیم
function updateBomPreview(bomId, options = {}) {
    const {
        quantitySelector = '#quantityInput',
        tableBodySelector = '#bomPreviewBody',
        quantity = parseFloat($(quantitySelector).val()) || 1,
        apiUrl = `/api/bom/${bomId}/components/`
    } = options;
    
    if(!bomId) {
        $(tableBodySelector).html(`
            <tr>
                <td colspan="4" class="text-center text-muted">Select a BOM to see components</td>
            </tr>
        `);
        return;
    }
    
    // Show loading state
    $(tableBodySelector).html(`
        <tr>
            <td colspan="4" class="text-center text-muted">
                <div class="spinner-border spinner-border-sm me-2" role="status"></div>
                Loading components...
            </td>
        </tr>
    `);
    
    return $.ajax({
        url: apiUrl,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            renderBomPreview(response, quantity, tableBodySelector);
        },
        error: function(xhr, status, error) {
            handleBomPreviewError(error, tableBodySelector);
        }
    });
}

// تابع برای رندر کردن پیش‌نمایش BOM
function renderBomPreview(response, quantity, tableBodySelector) {
    if(response.components && response.components.length > 0) {
        let bomRows = '';
        response.components.forEach(component => {
            const totalQty = component.quantity * quantity;
            const availableQty = component.available || component.stock_quantity || 0;
            const statusClass = totalQty <= availableQty ? 'bg-success' : 'bg-danger';
            const statusText = availableQty > 0 ? availableQty.toFixed(2) : 'N/A';
            
            bomRows += `
                <tr>
                    <td>${component.product_name || component.name}</td>
                    <td>${totalQty.toFixed(2)}</td>
                    <td>${component.uom_name || component.uom}</td>
                    <td><span class="badge ${statusClass}">${statusText}</span></td>
                </tr>
            `;
        });
        
        $(tableBodySelector).html(bomRows);
    } else {
        $(tableBodySelector).html(`
            <tr>
                <td colspan="4" class="text-center text-muted">No components defined for this BOM</td>
            </tr>
        `);
    }
}

// Function to update work order table
function updateWorkOrderTable() {
    const tbody = $('#workOrderTableBody');
    tbody.empty();
    
    workOrderList.forEach((wo, index) => {
        const row = `
            <tr>
                <td>${wo.id}</td>
                <td>
                    <select class="form-control work-order-select" data-index="${index}" data-field="workCenter">
                        ${workCenters.map(wc => `
                            <option value="${wc.name}" ${wc.name === wo.workCenter ? 'selected' : ''}>
                                ${wc.name}
                            </option>
                        `).join('')}
                    </select>
                </td>
                <td>
                    <input type="number" class="form-control duration-input" data-index="${index}" data-field="duration" 
                           value="${wo.duration}" min="0.1" step="0.1">
                </td>
                <td>
                    <input type="text" class="form-control description-input" data-index="${index}" data-field="description" 
                           value="${wo.description}">
                </td>
                <td>
                    <button class="btn btn-sm btn-outline-danger delete-work-order" data-index="${index}" title="Delete">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
        tbody.append(row);
    });
    
    if (workOrderList.length === 0) {
        tbody.append(`
            <tr>
                <td colspan="5" class="text-center text-muted">No work orders added</td>
            </tr>
        `);
    }
}

// Function to show forecast
function showForecast(bomId, quantity) {
    console.log('Generating forecast for BOM ID:', bomId, 'Quantity:', quantity);
    
    // Show loading state
    $('#forecastModal .modal-body').html(`
        <div class="text-center py-4">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2 text-muted">در حال محاسبه پیش‌بینی تولید...</p>
        </div>
    `);
    
    // Fetch forecast data
    Promise.all([
        fetchForecastData(bomId, quantity),
        fetchTimelineData(bomId)
    ]).then(([forecastData, timelineData]) => {
        renderForecastModal(forecastData, timelineData, quantity);
    }).catch(error => {
        console.error('Error loading forecast:', error);
        $('#forecastModal .modal-body').html(`
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                خطا در بارگذاری داده‌های پیش‌بینی: ${error.message}
            </div>
        `);
    });
}

// Fetch forecast data from API
function fetchForecastData(bomId, quantity) {
    return new Promise((resolve, reject) => {
        $.ajax({
            url: `/api/production-forecast/?bom_id=${bomId}&quantity=${quantity}`,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    resolve(response.forecast);
                } else {
                    reject(new Error(response.error));
                }
            },
            error: function(xhr, status, error) {
                reject(new Error('خطا در ارتباط با سرور'));
            }
        });
    });
}

// Fetch timeline data from API
function fetchTimelineData(bomId) {
    return new Promise((resolve, reject) => {
        $.ajax({
            url: `/api/bom/${bomId}/timeline/`,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    resolve(response);
                } else {
                    reject(new Error(response.error));
                }
            },
            error: function(xhr, status, error) {
                // اگر خطا داد، با داده‌های پیش‌فرض ادامه بده
                resolve({
                    timeline: [],
                    total_duration_hours: 0,
                    estimated_days: 0
                });
            }
        });
    });
}

// Render forecast modal with data
function renderForecastModal(forecastData, timelineData, quantity) {
    const modalBody = $('#forecastModal .modal-body');
    
    let html = `
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="alert alert-info">
                    <h6 class="alert-heading">خلاصه پیش‌بینی تولید</h6>
                    <hr>
                    <div class="row">
                        <div class="col-md-4">
                            <strong>محصول:</strong> ${forecastData.bom_info.product_name}
                        </div>
                        <div class="col-md-4">
                            <strong>تعداد تولید:</strong> ${quantity}
                        </div>
                        <div class="col-md-4">
                            <strong>BOM:</strong> ${forecastData.bom_info.reference}
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h6 class="mb-0"><i class="fas fa-chart-pie me-2"></i>وضعیت موجودی کامپوننت‌ها</h6>
                    </div>
                    <div class="card-body">
                        <canvas id="componentChart" class="forecast-chart mb-3"></canvas>
                        <div class="row text-center">
                            <div class="col-6">
                                <div class="text-success">
                                    <h4>${forecastData.summary.sufficient_components}</h4>
                                    <small>کافی</small>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="text-danger">
                                    <h4>${forecastData.summary.insufficient_components}</h4>
                                    <small>ناکافی</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h6 class="mb-0"><i class="fas fa-calculator me-2"></i>خلاصه مالی</h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <strong>هزینه کل مواد اولیه:</strong>
                            <h4 class="text-success">${forecastData.summary.total_required_cost.toLocaleString('fa-IR')} تومان</h4>
                        </div>
                        <div class="mb-3">
                            <strong>زمان تولید تخمینی:</strong>
                            <h5>${forecastData.summary.production_time_hours.toFixed(1)} ساعت</h5>
                        </div>
                        <div class="progress mb-3" style="height: 10px;">
                            <div class="progress-bar bg-success" style="width: ${(forecastData.summary.sufficient_components / forecastData.bom_info.total_components * 100)}%">
                            </div>
                        </div>
                        <small class="text-muted">
                            ${forecastData.summary.sufficient_components} از ${forecastData.bom_info.total_components} کامپوننت موجود است
                        </small>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h6 class="mb-0"><i class="fas fa-list-alt me-2"></i>جزئیات کامپوننت‌ها</h6>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-sm table-striped">
                                <thead>
                                    <tr>
                                        <th>نام کامپوننت</th>
                                        <th>مقدار مورد نیاز</th>
                                        <th>موجودی</th>
                                        <th>کمبود</th>
                                        <th>هزینه</th>
                                        <th>وضعیت</th>
                                    </tr>
                                </thead>
                                <tbody>
    `;
    
    // Add components rows
    forecastData.components_analysis.forEach(component => {
        const statusClass = component.is_sufficient ? 'success' : 'danger';
        const statusText = component.is_sufficient ? 'کافی' : 'ناکافی';
        const statusIcon = component.is_sufficient ? 'fa-check' : 'fa-exclamation-triangle';
        
        html += `
            <tr>
                <td>${component.name}</td>
                <td>${component.required_quantity.toFixed(2)} ${component.uom}</td>
                <td>${component.available_quantity.toFixed(2)} ${component.uom}</td>
                <td>${component.shortage.toFixed(2)} ${component.uom}</td>
                <td>${component.cost.toLocaleString('fa-IR')} تومان</td>
                <td>
                    <span class="badge bg-${statusClass}">
                        <i class="fas ${statusIcon} me-1"></i>${statusText}
                    </span>
                </td>
            </tr>
        `;
    });
    
    html += `
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0"><i class="fas fa-project-diagram me-2"></i>زمان‌بندی تولید</h6>
                    </div>
                    <div class="card-body">
    `;
    
    if (timelineData.timeline && timelineData.timeline.length > 0) {
        html += `
            <div class="mb-3">
                <strong>مدت زمان کل:</strong> ${timelineData.total_duration_hours.toFixed(1)} ساعت 
                (${timelineData.estimated_days.toFixed(1)} روز کاری)
            </div>
            <div class="table-responsive">
                <table class="table table-sm">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>قالب دستور کار</th>
                            <th>عملیات</th>
                            <th>مرکز کار</th>
                            <th>مدت زمان (ساعت)</th>
                            <th>دستورالعمل</th>
                        </tr>
                    </thead>
                    <tbody>
        `;
        
        timelineData.timeline.forEach((operation, index) => {
            html += `
                <tr>
                    <td>${index + 1}</td>
                    <td>${operation.template_name}</td>
                    <td>${operation.operation_name}</td>
                    <td>${operation.work_center}</td>
                    <td>${operation.duration_hours}</td>
                    <td>${operation.instructions || '-'}</td>
                </tr>
            `;
        });
        
        html += `
                    </tbody>
                </table>
            </div>
        `;
    } else {
        html += `
            <div class="alert alert-warning">
                <i class="fas fa-info-circle"></i>
                هیچ قالب دستور کاری برای این BOM تعریف نشده است.
            </div>
        `;
    }
    
    html += `
                    </div>
                </div>
            </div>
        </div>
    `;
    
    modalBody.html(html);
    
    // Render chart
    renderForecastChart(forecastData);
}

// Render forecast chart
function renderForecastChart(forecastData) {
    const ctx = document.getElementById('componentChart').getContext('2d');
    
    // Destroy previous chart if exists
    if (window.componentChart instanceof Chart) {
        window.componentChart.destroy();
    }
    
    const labels = forecastData.components_analysis.map(c => c.name);
    const requiredData = forecastData.components_analysis.map(c => c.required_quantity);
    const availableData = forecastData.components_analysis.map(c => c.available_quantity);
    
    window.componentChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [
                {
                    label: 'مقدار مورد نیاز',
                    data: requiredData,
                    backgroundColor: 'rgba(255, 99, 132, 0.7)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                },
                {
                    label: 'موجودی',
                    data: availableData,
                    backgroundColor: 'rgba(75, 192, 192, 0.7)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'مقدار'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: 'کامپوننت‌ها'
                    }
                }
            },
            plugins: {
                legend: {
                    position: 'top',
                    rtl: true
                },
                title: {
                    display: true,
                    text: 'مقایسه مقدار مورد نیاز و موجودی'
                }
            }
        }
    });
}
var loadForm =function (btn1) {
    var btn=0;
    if($(btn1).attr("type")=="click")
     btn=$(this);
    else {
      btn=btn1;
    }
    console.log(btn.attr("data-url"));

    return $.ajax({
      url: btn.attr("data-url"),
      type: 'get',
      dataType: 'json',
      beforeSend: function () {
        
        $("#newOrderModal").modal("show");
      },
      success: function (data) {
        

        $("#newOrderModal .modal-content").html(data.html_morder_form);
        $("#id_product_to_manufacture").select2({dropdownParent: $('#newOrderModal')});
        $("#productSelect").select2({dropdownParent: $('#newOrderModal')});
       
        $('.pdate').pDatepicker({
            format: 'YYYY-MM-DD',
            autoClose: true,
            initialValueType: 'gregorian',
            calendar:{
              persian: {
                  leapYearMode: 'astronomical'
              }
          },
          persianDigit: false,  // This should disable Persian digits
          });
        // $('[data-input-mask="date"]').mask('0000-00-00');
        // loadOrdersTable();
        // loadGridView();
        
        // Load dropdown options
        loadProductOptions();
        loadCustomerOptions();
        loadResponsibleOptions();
        // const productId =$("#id_product_to_manufacture").val();
        // // console.log();
        
        // loadBomOptions2(productId);
        
        // $(".select2").select2();
        const bomId=$("#id_bom").val();
        if(bomId){
        updateBomPreview(bomId);
      }


      }
    });



};
function convertPersianToEnglish(str) {
    if (!str) return str;
    
    var persianNumbers = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    for (var i = 0; i < 10; i++) {
        str = str.replace(new RegExp(persianNumbers[i], 'g'), englishNumbers[i]);
    }
    return str;
}
var saveForm= function () {
    $('.pdate').each(function() {
        var persianDate = $(this).val();
        var englishDate = convertPersianToEnglish(persianDate);
        $(this).val(englishDate);
    });
    var form = $(this);

    console.log(form);
    
    $.ajax({
      url: form.attr("action"),
      data: form.serialize(),
      type: form.attr("method"),
      dataType: 'json',
      beforeSend:function(){
       
        console.log(form.serialize());

      },
      success: function (data) {
        console.log(data);

        if (data.form_is_valid) {
          $("#newOrderModal").modal("hide");
          load_morders();
            
        }
        else {
            
          $("#company-table tbody").html(data.html_assetFailure_list);
          $("#modal-company .modal-content").html(data.html_assetFailure_form);
        }
      }
    });
    return false;
  };

$("#createNewMorder").click(loadForm);
$("#newOrderModal").on("submit", ".js-morder-create-form", saveForm);
$("#tableView").on("click", ".js-morder-edit", loadForm);
$("#newOrderModal").on("submit", ".js-morder-update-form", saveForm);
$("#newOrderModal").on("load", function(){
    
});


});