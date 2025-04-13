// Global variables
let currentBomId = null;
let currentPage = 1;
const itemsPerPage = 5;
let currentView = 'table'; // 'table' or 'grid'

// Mock data
const mockProducts = [
    { id: 101, name: "Finished Product A" },
    { id: 102, name: "Finished Product B" },
    { id: 103, name: "Finished Product C" },
    { id: 104, name: "Finished Product D" },
    { id: 105, name: "Finished Product E" },
    { id: 106, name: "Finished Product F" }
];

const mockComponents = [
    { id: 201, name: "Component X" },
    { id: 202, name: "Component Y" },
    { id: 203, name: "Component Z" },
    { id: 204, name: "Component A" },
    { id: 205, name: "Component B" },
    { id: 206, name: "Component C" }
];

const mockBoms = [
    {
        id: 1,
        reference: "BOM-001",
        product: { id: 101, name: "Finished Product A" },
        operation_time: 45.5,
        updated_at: "2023-06-15T14:30:00Z",
        components: [
            { id: 201, product: { id: 201, name: "Component X" }, quantity: 2, uom: "units" },
            { id: 202, product: { id: 202, name: "Component Y" }, quantity: 1.5, uom: "kg" }
        ]
    },
    {
        id: 2,
        reference: "BOM-002",
        product: { id: 102, name: "Finished Product B" },
        operation_time: 30.0,
        updated_at: "2023-06-10T09:15:00Z",
        components: [
            { id: 203, product: { id: 203, name: "Component Z" }, quantity: 3, uom: "units" }
        ]
    },
    {
        id: 3,
        reference: "BOM-003",
        product: { id: 103, name: "Finished Product C" },
        operation_time: 60.0,
        updated_at: "2023-06-18T10:20:00Z",
        components: [
            { id: 204, product: { id: 204, name: "Component A" }, quantity: 4, uom: "units" },
            { id: 205, product: { id: 205, name: "Component B" }, quantity: 2.5, uom: "kg" },
            { id: 206, product: { id: 206, name: "Component C" }, quantity: 1, uom: "l" }
        ]
    },
    {
        id: 4,
        reference: "BOM-004",
        product: { id: 104, name: "Finished Product D" },
        operation_time: 25.0,
        updated_at: "2023-06-20T08:45:00Z",
        components: [
            { id: 207, product: { id: 207, name: "Component D" }, quantity: 2, uom: "units" }
        ]
    },
    {
        id: 5,
        reference: "BOM-005",
        product: { id: 105, name: "Finished Product E" },
        operation_time: 35.5,
        updated_at: "2023-06-22T16:10:00Z",
        components: []
    },
    {
        id: 6,
        reference: "BOM-006",
        product: { id: 106, name: "Finished Product F" },
        operation_time: 42.0,
        updated_at: "2023-06-25T11:30:00Z",
        components: [
            { id: 208, product: { id: 208, name: "Component E" }, quantity: 3, uom: "units" },
            { id: 209, product: { id: 209, name: "Component F" }, quantity: 1.2, uom: "kg" }
        ]
    }
];

// Initialize the page
$(document).ready(function() {
    loadBomList();
    initProductFilter();
    initComponentForm();
    
    // Event handlers
    $('#create-bom-btn').click(showCreateBomModal);
    $('#edit-bom-btn').click(showEditBomModal);
    $('#delete-bom-btn').click(showDeleteConfirmModal);
    $('#save-bom-btn').click(saveBom);
    $('#add-component-btn').click(showAddComponentModal);
    $('#save-component-btn').click(saveComponent);
    $('#confirm-delete-btn').click(deleteBom);
    $('#print-bom-btn').click(printBom);
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
        
        if (pageText === 'previous' && currentPage > 1) {
            currentPage--;
            loadBomList();
        } else if (pageText === 'next') {
            currentPage++;
            loadBomList();
        } else if (!isNaN(pageText)) {
            currentPage = parseInt(pageText);
            loadBomList();
        }
    });
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
    $productFilter.empty().append('<option value="">Filter by Product</option>');
    
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

// Load BOM list
function loadBomList() {
    // Apply filtering if any
    const filteredBoms = filterBomData(mockBoms);
    const totalItems = filteredBoms.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);
    
    // Paginate the data
    const startIndex = (currentPage - 1) * itemsPerPage;
    const paginatedBoms = filteredBoms.slice(startIndex, startIndex + itemsPerPage);
    
    // Update count info
    const startItem = startIndex + 1;
    const endItem = Math.min(startIndex + itemsPerPage, totalItems);
    $('#table-count-info').text(`Showing ${startItem}-${endItem} of ${totalItems} BOMs`);
    
    // Update pagination controls
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
            <a class="page-link" href="#" tabindex="-1">Previous</a>
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
            <a class="page-link" href="#">Next</a>
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
                <td>${bom.components.length} components</td>
                <td>${bom.operation_time} min</td>
                <td>${formatDate(bom.updated_at)}</td>
                <td>
                    <button class="btn btn-sm btn-outline-primary view-bom-btn" data-bom-id="${bom.id}">
                        <i class="fas fa-eye"></i> View
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
                <div class="card-header">
                    <h5 class="card-title mb-0">${bom.reference}</h5>
                </div>
                <div class="card-body">
                    <p class="card-text"><strong>Product:</strong> ${bom.product.name}</p>
                    <p class="card-text"><strong>Components:</strong> ${bom.components.length}</p>
                    <p class="card-text"><strong>Operation Time:</strong> ${bom.operation_time} min</p>
                    <p class="card-text"><small class="text-muted">Last updated: ${formatDate(bom.updated_at)}</small></p>
                </div>
                <div class="card-footer bg-transparent">
                    <button class="btn btn-sm btn-outline-primary view-bom-btn" data-bom-id="${bom.id}">
                        <i class="fas fa-eye"></i> View
                    </button>
                    <button class="btn btn-sm btn-outline-secondary edit-bom-btn" data-bom-id="${bom.id}">
                        <i class="fas fa-edit"></i> Edit
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
    const bom = mockBoms.find(b => b.id == bomId);
    
    if (bom) {
        // Update header info
        $('#bom-reference').text(bom.reference);
        $('#bom-product').text(bom.product.name);
        $('#bom-operation-time').text(bom.operation_time);
        $('#bom-updated-at').text(formatDate(bom.updated_at));
        
        // Update components table
        if (bom.components.length > 0) {
            $('#empty-components').hide();
            $('#component-table-body').empty();
            
            bom.components.forEach(component => {
                const componentRow = $(`
                    <tr data-component-id="${component.id}">
                        <td>${component.product.name}</td>
                        <td>${component.quantity}</td>
                        <td>${component.uom}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-danger remove-component-btn">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `);
                
                componentRow.find('.remove-component-btn').click(function() {
                    if (confirm('Are you sure you want to remove this component?')) {
                        // In a real app, AJAX call to delete from backend
                        console.log('Removing component:', component.id);
                        componentRow.remove();
                        
                        if ($('#component-table-body tr:not(#empty-components)').length === 0) {
                            $('#empty-components').show();
                        }
                    }
                });
                
                $('#component-table-body').append(componentRow);
            });
        } else {
            $('#empty-components').show();
            $('#component-table-body').empty();
        }
    }
}

// Show create BOM modal
function showCreateBomModal() {
    $('#bom-modal-title').text('Create New BOM');
    $('#bom-id').val('');
    $('#bom-form')[0].reset();
    
    // Populate product dropdown
    const $productSelect = $('#product');
    $productSelect.empty().append('<option value="">Select a product</option>');
    mockProducts.forEach(product => {
        $productSelect.append(`<option value="${product.id}">${product.name}</option>`);
    });
    
    $('#bom-form-modal').modal('show');
}

// Show edit BOM modal
function showEditBomModal(bomId = null) {
    const editBomId = bomId || currentBomId;
    if (!editBomId) return;
    
    const bom = mockBoms.find(b => b.id == editBomId);
    if (bom) {
        $('#bom-modal-title').text('Edit BOM');
        $('#bom-id').val(bom.id);
        $('#reference').val(bom.reference);
        $('#operation-time').val(bom.operation_time);
        
        // Populate product dropdown
        const $productSelect = $('#product');
        $productSelect.empty().append('<option value="">Select a product</option>');
        mockProducts.forEach(product => {
            $productSelect.append(`<option value="${product.id}" ${product.id === bom.product.id ? 'selected' : ''}>${product.name}</option>`);
        });
        
        $('#bom-form-modal').modal('show');
    }
}

// Save BOM (create or update)
function saveBom() {
    const form = $('#bom-form')[0];
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    const bomData = {
        id: $('#bom-id').val(),
        reference: $('#reference').val(),
        product_id: $('#product').val(),
        product_name: $('#product option:selected').text(),
        operation_time: $('#operation-time').val()
    };
    
    // In a real app, this would be an AJAX call to your backend
    console.log('Saving BOM:', bomData);
    
    // Simulate success
    $('#bom-form-modal').modal('hide');
    
    if (bomData.id) {
        // Update existing BOM
        const index = mockBoms.findIndex(b => b.id == bomData.id);
        if (index !== -1) {
            mockBoms[index] = {
                ...mockBoms[index],
                reference: bomData.reference,
                product: {
                    id: bomData.product_id,
                    name: bomData.product_name
                },
                operation_time: bomData.operation_time
            };
        }
        showToast('BOM updated successfully!', 'success');
    } else {
        // Create new BOM
        const newBom = {
            id: Math.max(...mockBoms.map(b => b.id)) + 1,
            reference: bomData.reference,
            product: {
                id: bomData.product_id,
                name: bomData.product_name
            },
            operation_time: bomData.operation_time,
            updated_at: new Date().toISOString(),
            components: []
        };
        mockBoms.push(newBom);
        showToast('BOM created successfully!', 'success');
    }
    
    loadBomList();
}

// Show add component modal
function showAddComponentModal() {
    if (!currentBomId) return;
    
    // Reset form and set current BOM ID
    $('#component-form')[0].reset();
    $('#component-bom-id').val(currentBomId);
    
    // Populate component dropdown
    const $componentSelect = $('#component-product');
    $componentSelect.empty().append('<option value="">Select a component</option>');
    mockComponents.forEach(component => {
        $componentSelect.append(`<option value="${component.id}">${component.name}</option>`);
    });
    
    $('#component-form-modal').modal('show');
}

// Save component
function saveComponent() {
    const form = $('#component-form')[0];
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    const componentData = {
        bom_id: $('#component-bom-id').val(),
        product_id: $('#component-product').val(),
        product_name: $('#component-product option:selected').text(),
        quantity: $('#quantity').val(),
        uom: $('#uom').val()
    };
    
    // In a real app, this would be an AJAX call to your backend
    console.log('Adding component:', componentData);
    
    // Simulate success
    $('#component-form-modal').modal('hide');
    
    // Find the BOM
    const bomIndex = mockBoms.findIndex(b => b.id == componentData.bom_id);
    if (bomIndex !== -1) {
        // Add the component
        const newComponent = {
            id: Math.max(0, ...mockBoms[bomIndex].components.map(c => c.id)) + 1,
            product: {
                id: componentData.product_id,
                name: componentData.product_name
            },
            quantity: parseFloat(componentData.quantity),
            uom: componentData.uom
        };
        
        mockBoms[bomIndex].components.push(newComponent);
        loadBomDetails(currentBomId);
        showToast('Component added successfully!', 'success');
    }
}

// Show delete confirmation modal
function showDeleteConfirmModal() {
    if (!currentBomId) return;
    $('#delete-confirm-modal').modal('show');
}

// Delete BOM
function deleteBom() {
    $('#delete-confirm-modal').modal('hide');
    
    // In a real app, this would be an AJAX call to your backend
    console.log('Deleting BOM:', currentBomId);
    
    // Remove from mock data
    const index = mockBoms.findIndex(b => b.id == currentBomId);
    if (index !== -1) {
        mockBoms.splice(index, 1);
    }
    
    // Reset and refresh
    currentBomId = null;
    loadBomList();
    $('#bom-detail-modal').modal('hide');
    showToast('BOM deleted successfully!', 'success');
}

// Print BOM
function printBom() {
    if (!currentBomId) return;
    window.print();
}

// Filter BOMs
function filterBoms() {
    currentPage = 1; // Reset to first page when filtering
    loadBomList();
}

// Helper function to format date
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
}

// Helper function to show toast messages
function showToast(message, type = 'success') {
    // In a real app, you would use a proper toast library
    alert(`${type.toUpperCase()}: ${message}`);
}