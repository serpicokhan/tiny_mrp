$(function () {
// Sample JSON data
const manufacturingOrders = [
    {
        id: 1,
        reference: "MO/2023/0001",
        product: { id: 1, name: "Office Desk", code: "OD-1001", image: "/media/products/office-desk.jpg" },
        quantity: 10.0,
        bom: "BOM-OD-1001",
        workOrders: [{ id: "WO-2023-001", workCenter: "Assembly Line 1", duration: 2.5, description: "Assemble desk frame" }],
        status: "draft",
        scheduledDate: "2023-06-15",
        customer: { id: 1, name: "Acme Corp" },
        responsible: { id: 1, name: "John Doe" },
        notes: "Urgent order for client XYZ"
    },
    {
        id: 2,
        reference: "MO/2023/0002",
        product: { id: 2, name: "Office Chair", code: "OC-2001", image: "/media/products/office-chair.jpg" },
        quantity: 15.0,
        bom: "BOM-OC-2001",
        workOrders: [{ id: "WO-2023-002", workCenter: "Assembly Line 2", duration: 3.0, description: "Chair assembly and upholstery" }],
        status: "confirmed",
        scheduledDate: "2023-06-16",
        customer: { id: 2, name: "Beta Industries" },
        responsible: { id: 2, name: "Jane Smith" },
        notes: "Standard production"
    },
    {
        id: 3,
        reference: "MO/2023/0003",
        product: { id: 3, name: "Bookshelf", code: "BS-3001", image: "/media/products/bookshelf.jpg" },
        quantity: 5.0,
        bom: "BOM-BS-3001",
        workOrders: [{ id: "WO-2023-003", workCenter: "Finishing Station", duration: 4.0, description: "Apply custom color finish" }],
        status: "progress",
        scheduledDate: "2023-06-14",
        customer: { id: 3, name: "Gamma Retail" },
        responsible: { id: 3, name: "Mike Johnson" },
        notes: "Custom color requested"
    },
    {
        id: 4,
        reference: "MO/2023/0004",
        product: { id: 4, name: "Coffee Table", code: "CT-4001", image: "/media/products/coffee-table.jpg" },
        quantity: 8.0,
        bom: "BOM-CT-4001",
        workOrders: [],
        status: "done",
        scheduledDate: "2023-06-10",
        customer: null,
        responsible: { id: 4, name: "Sarah Williams" },
        notes: "Completed ahead of schedule"
    },
    {
        id: 5,
        reference: "MO/2023/0005",
        product: { id: 1, name: "Office Desk", code: "OD-1001", image: "/media/products/office-desk.jpg" },
        quantity: 12.0,
        bom: "BOM-OD-1001",
        workOrders: [{ id: "WO-2023-004", workCenter: "Packaging", duration: 1.5, description: "Pack desks for shipping" }],
        status: "canceled",
        scheduledDate: "2023-06-12",
        customer: { id: 1, name: "Acme Corp" },
        responsible: { id: 1, name: "John Doe" },
        notes: "Client canceled order"
    },
    {
        id: 6,
        reference: "MO/2023/0006",
        product: { id: 2, name: "Office Chair", code: "OC-2001", image: "/media/products/office-chair.jpg" },
        quantity: 20.0,
        bom: "BOM-OC-2001",
        workOrders: [{ id: "WO-2023-002", workCenter: "Assembly Line 2", duration: 3.0, description: "Bulk chair assembly" }],
        status: "confirmed",
        scheduledDate: "2023-06-18",
        customer: { id: 2, name: "Beta Industries" },
        responsible: { id: 2, name: "Jane Smith" },
        notes: "Bulk order for new office"
    },
    {
        id: 7,
        reference: "MO/2023/0007",
        product: { id: 3, name: "Bookshelf", code: "BS-3001", image: "/media/products/bookshelf.jpg" },
        quantity: 3.0,
        bom: "BOM-BS-3001",
        workOrders: [{ id: "WO-2023-003", workCenter: "Finishing Station", duration: 4.0, description: "Glass door installation" }],
        status: "progress",
        scheduledDate: "2023-06-17",
        customer: { id: 3, name: "Gamma Retail" },
        responsible: { id: 3, name: "Mike Johnson" },
        notes: "Special edition with glass doors"
    },
    {
        id: 8,
        reference: "MO/2023/0008",
        product: { id: 4, name: "Coffee Table", code: "CT-4001", image: "/media/products/coffee-table.jpg" },
        quantity: 6.0,
        bom: "BOM-CT-4001",
        workOrders: [{ id: "WO-2023-001", workCenter: "Assembly Line 1", duration: 2.0, description: "Table frame assembly" }],
        status: "draft",
        scheduledDate: "2023-06-20",
        customer: null,
        responsible: { id: 4, name: "Sarah Williams" },
        notes: "Waiting for client confirmation"
    }
];

const products = [
    { id: 1, name: "Office Desk", code: "OD-1001", image: "/media/products/office-desk.jpg" },
    { id: 2, name: "Office Chair", code: "OC-2001", image: "/media/products/office-chair.jpg" },
    { id: 3, name: "Bookshelf", code: "BS-3001", image: "/media/products/bookshelf.jpg" },
    { id: 4, name: "Coffee Table", code: "CT-4001", image: "/media/products/coffee-table.jpg" }
];

const boms = [
    { id: 1, name: "BOM-OD-1001", productId: 1, description: "Office Desk" },
    { id: 2, name: "BOM-OC-2001", productId: 2, description: "Office Chair" },
    { id: 3, name: "BOM-BS-3001", productId: 3, description: "Bookshelf" },
    { id: 4, name: "BOM-CT-4001", productId: 4, description: "Coffee Table" }
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

const customers = [
    { id: 1, name: "Acme Corp" },
    { id: 2, name: "Beta Industries" },
    { id: 3, name: "Gamma Retail" },
    { id: 4, name: "Delta Enterprises" }
];

const workCenters = [
    { id: 1, name: "Assembly Line 1" },
    { id: 2, name: "Assembly Line 2" },
    { id: 3, name: "Finishing Station" },
    { id: 4, name: "Packaging" }
];

let workOrderList = [];
let componentChart = null;

$(document).ready(function() {
    // Load data into views
    loadOrdersTable();
    loadGridView();
    
    // Load dropdown options
    loadProductOptions();
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

    // Function to update forecast button state
    function updateForecastButtonState() {
        const productId = $('#productSelect').val();
        const bomId = $('#bomSelect').val();
        const quantity = parseFloat($('#quantityInput').val());
        const isValid = productId && bomId && quantity > 0;
        $('#forecastBtn').prop('disabled', !isValid);
    }

    // Product select change - update BOM options
    $('#productSelect').change(function() {
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

    // BOM select change - update component preview
    $('#bomSelect').change(function() {
        const bomId = $(this).val();
        if(bomId) {
            $('#bomPreviewBody').html(`
                <tr>
                    <td colspan="4" class="text-center">
                        <div class="spinner-border spinner-border-sm" role="status">
                            <span class="visually-hidden">Loading...</span>
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
    $('#quantityInput').on('input change', function() {
        const bomId = $('#bomSelect').val();
        if(bomId) {
            updateBomPreview(bomId);
        }
        updateForecastButtonState();
    });

    // Add Work Order button
    $('#addWorkOrderBtn').click(function() {
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
    $('#forecastBtn').click(function() {
        console.log('Forecast button clicked');
        const productId = $('#productSelect').val();
        const bomId = $('#bomSelect').val();
        const quantity = parseFloat($('#quantityInput').val());

        if (!productId) {
            alert('Please select a product.');
            return;
        }
        if (!bomId) {
            alert('Please select a Bill of Materials.');
            return;
        }
        if (!quantity || quantity <= 0) {
            alert('Please enter a valid quantity greater than 0.');
            return;
        }

        console.log('Showing forecast for Product ID:', productId, 'BOM ID:', bomId, 'Quantity:', quantity);
        showForecast(bomId, quantity);
        $('#forecastModal').modal('show');
    });
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
                    <button class="btn btn-sm btn-outline-primary me-1" title="View">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-secondary" title="Edit">
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
                    <img src="${order.product.image}" class="product-image me-2">
                    <div>${order.product.name} (${order.product.code})</div>
                </div>
                <div class="grid-card-details">
                    <div><strong>Quantity:</strong> ${order.quantity.toFixed(1)}</div>
                    <div><strong>BOM:</strong> ${order.bom}</div>
                    <div><strong>Work Orders:</strong> ${workOrderText}</div>
                    <div><strong>Scheduled Date:</strong> ${order.scheduledDate}</div>
                    <div><strong>Customer:</strong> ${order.customer ? order.customer.name : 'None'}</div>
                    <div><strong>Responsible:</strong> ${order.responsible ? order.responsible.name : 'None'}</div>
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
function loadProductOptions() {
    const select = $('#productSelect');
    select.empty();
    select.append('<option value="" selected disabled>Select a product</option>');
    
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
    const select = $('#responsibleSelect');
    select.empty();
    select.append('<option value="" selected>No responsible</option>');
    
    responsibles.forEach(responsible => {
        select.append(`<option value="${responsible.id}">${responsible.name}</option>`);
    });
}

// Function to load BOM options based on product
function loadBomOptions(productId) {
    const select = $('#bomSelect');
    select.empty();
    select.append('<option value="" selected disabled>Select a BOM</option>');
    
    if (!productId) return;
    
    const productBoms = boms.filter(bom => bom.productId == productId);
    
    if (productBoms.length === 0) {
        select.append('<option value="" disabled>No BOMs available for this product</option>');
    } else {
        productBoms.forEach(bom => {
            select.append(`<option value="${bom.id}">${bom.name} - ${bom.description}</option>`);
        });
    }
}

// Function to update BOM preview
function updateBomPreview(bomId) {
    const quantity = parseFloat($('#quantityInput').val()) || 1;
    
    if(!bomId) {
        $('#bomPreviewBody').html(`
            <tr>
                <td colspan="4" class="text-center text-muted">Select a BOM to see components</td>
            </tr>
        `);
        return;
    }
    
    const bomData = bomComponents.find(bc => bc.bomId == bomId);
    let components = [];
    
    if(bomData) {
        components = bomData.components;
    }
    
    if(components.length === 0) {
        $('#bomPreviewBody').html(`
            <tr>
                <td colspan="4" class="text-center text-muted">No components defined for this BOM</td>
            </tr>
        `);
        return;
    }
    
    // Generate the BOM preview rows
    let bomRows = '';
    components.forEach(component => {
        const totalQty = component.qty * quantity;
        const statusClass = totalQty <= component.available ? 'bg-success' : 'bg-danger';
        
        bomRows += `
            <tr>
                <td>${component.name}</td>
                <td>${totalQty.toFixed(1)}</td>
                <td>${component.uom}</td>
                <td><span class="badge ${statusClass}">${component.available.toFixed(1)}</span></td>
            </tr>
        `;
    });
    
    $('#bomPreviewBody').html(bomRows);
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
                    <select class="form-select work-order-select" data-index="${index}" data-field="workCenter">
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
    console.log('Generating forecast for BOM ID:', bomId);
    const bomData = bomComponents.find(bc => bc.bomId == bomId);
    const components = bomData ? bomData.components : [];
    
    // Destroy previous chart if it exists
    if (componentChart) {
        componentChart.destroy();
    }

    // Component Availability Chart
    const labels = components.map(c => c.name);
    const requiredData = components.map(c => c.qty * quantity);
    const availableData = components.map(c => c.available);

    const ctx = document.getElementById('componentChart').getContext('2d');
    try {
        componentChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Required Quantity',
                        data: requiredData,
                        backgroundColor: 'rgba(0, 123, 255, 0.5)',
                        borderColor: 'rgba(0, 123, 255, 1)',
                        borderWidth: 1
                    },
                    {
                        label: 'Available Quantity',
                        data: availableData,
                        backgroundColor: 'rgba(40, 167, 69, 0.5)',
                        borderColor: 'rgba(40, 167, 69, 1)',
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
                            text: 'Quantity'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Components'
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top'
                    },
                    title: {
                        display: true,
                        text: 'Component Availability Forecast'
                    }
                }
            }
        });
        console.log('Chart created successfully');
    } catch (e) {
        console.error('Error creating chart:', e);
    }

    // Production Timeline
    const totalDuration = workOrderList.reduce((sum, wo) => sum + parseFloat(wo.duration), 0);
    const timelineHtml = workOrderList.length > 0 ? `
        <p><strong>Total Duration:</strong> ${totalDuration.toFixed(1)} hours</p>
        <ul>
            ${workOrderList.map(wo => `
                <li>${wo.id} (${wo.workCenter}): ${wo.duration} hours - ${wo.description || 'No description'}</li>
            `).join('')}
        </ul>
    ` : '<p class="text-muted">No work orders added to estimate production timeline.</p>';
    $('#timelineInfo').html(timelineHtml);

    // Stock Status
    const allSufficient = components.every(c => c.qty * quantity <= c.available);
    const stockStatusHtml = components.length > 0 ? `
        <p><strong>Stock Sufficiency:</strong> 
            <span class="${allSufficient ? 'text-success' : 'text-danger'}">
                ${allSufficient ? 'Sufficient stock for all components' : 'Insufficient stock for some components'}
            </span>
        </p>
        <ul>
            ${components.map(c => `
                <li>${c.name}: ${c.qty * quantity.toFixed(1)} required, ${c.available.toFixed(1)} available 
                    <span class="${c.qty * quantity <= c.available ? 'text-success' : 'text-danger'}">
                        (${c.qty * quantity <= c.available ? 'OK' : 'Shortage'})
                    </span>
                </li>
            `).join('')}
        </ul>
    ` : '<p class="text-muted">No components defined for this BOM.</p>';
    $('#stockStatus').html(stockStatusHtml);
}
});