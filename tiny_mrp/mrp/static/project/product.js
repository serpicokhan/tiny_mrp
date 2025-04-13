

$(function () {
    let currentProductId = null;
    let currentView = 'grid'; // 'grid' or 'list'
    function refreshList() {
        const currentParams = new URLSearchParams(window.location.search);

        // Save them globally for later use
        const filters = {};
        for (const [key, value] of currentParams.entries()) {
            filters[key] = value;
        }
        // Send the query parameters with the list reload request
        const params = new URLSearchParams(filters).toString();
    
        $.ajax({
            url: `/Product/RefereshList?${params}`, // Append filters to the URL
            method: 'GET',
            success: function (data) {
                // $('#list-container').html(data.parchase_req_html);
                if(data.status="ok"){
                $("#main_ul").html('');
                $("#main_ul").html(data.parchase_req_html);
                }
            },
        });
        console.log(params);
    }
    // Initialize the page
    loadProducts();
    
    // Event handlers
    $('#create-product-btn').click(loadForm);
    $('#save-product-btn').click(saveProduct);
    $('#confirm-delete-btn').click(deleteProduct);
    $('#product-search').on('keyup', filterProducts);
    $('#type-filter, #stock-filter').change(filterProducts);
    $('#view-grid-btn').click(function() {
        setView('grid');
    });
    $('#view-list-btn').click(function() {
        setView('list');
    });
    
    // Set view type (grid or list)
    function setView(view) {
        currentView = view;
        if (view === 'grid') {
            $('#grid-view').show();
            $('#list-view').hide();
            $('#view-grid-btn').addClass('active');
            $('#view-list-btn').removeClass('active');
        } else {
            $('#grid-view').hide();
            $('#list-view').show();
            $('#view-grid-btn').removeClass('active');
            $('#view-list-btn').addClass('active');
        }
    }
    
    // Load products from server
    let mockProducts=[];
    function loadProducts() {

        // In a real app, this would be an AJAX call to your Django backend
        // For demo purposes, we'll use mock data
        $.ajax({
            url: '/api/products/',  // Your Django endpoint
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                // Process the response data (similar to your mockProducts)
                // console.log('Received products:', response);
                mockProducts=response
                // Example: Display products in a table
                if (mockProducts.length > 0) {
                    renderProductGrid(mockProducts);
                    renderProductTable(mockProducts);
                } else {
                    $('#empty-products-grid').show();
                    $('#empty-products-table').show();
                }
            },
            error: function(xhr, status, error) {
                console.error('Error fetching products:', error);
            }
        });
        
       
    }
    // Render product grid
    function renderProductGrid(products) {
        if (products.length > 0) {
            $('#empty-products-grid').hide();
            $('#grid-view').empty();
            
            products.forEach(product => {
                const stockClass = getStockClass(product.available_quantity);
                const typeBadgeClass = product.product_type === 'finished' ? 'bg-success' : 
                                     product.product_type === 'raw' ? 'bg-warning text-dark' : 'bg-info';
                const typeLabel = product.product_type === 'finished' ? 'Finished' : 
                                 product.product_type === 'raw' ? 'Raw' : 'Component';
                
                const productCard = $(`
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="card product-card" data-product-id="${product.id}">
                            <span class="badge ${typeBadgeClass} product-type-badge">${typeLabel}</span>
                            <div class="card-body">
                                <h5 class="card-title">${product.name}</h5>
                                <h6 class="card-subtitle mb-2 text-muted">${product.code}</h6>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="product-price product-cost">$${product.cost_price}</span>
                                    <span class="product-price product-sale">$${product.sale_price}</span>
                                </div>
                                <p class="card-text">
                                    <span class="product-stock ${stockClass}">
                                        ${product.available_quantity} ${product.unit_of_measure}
                                    </span>
                                </p>
                                <div class="d-flex justify-content-between action-buttons">
                                    <button class="btn btn-sm btn-outline-primary edit-product-btn">
                                        <i class="fas fa-edit mr-1"></i> ویرایش
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger delete-product-btn">
                                        <i class="fas fa-trash mr-1"></i> حذف
                                    </button>
                                </div>
                            </div>
                            <div class="card-footer text-muted small">
                                Last updated: ${formatDate(product.updated_at)}
                            </div>
                        </div>
                    </div>
                `);
                
                productCard.find('.edit-product-btn').click(function() {
                    showEditProductModal(product.id);
                });
                
                productCard.find('.delete-product-btn').click(function() {
                    showDeleteConfirmModal(product.id);
                });
                
                $('#grid-view').append(productCard);
            });
        } else {
            $('#empty-products-grid').show();
        }
    }
    
    // Render product table
    function renderProductTable(products) {
        if (products.length > 0) {
            $('#empty-products-table').hide();
            $('#product-table-body').empty();
            
            products.forEach(product => {
                const stockClass = getStockClass(product.available_quantity);
                const typeLabel = product.product_type === 'finished' ? 'Finished' : 
                                 product.product_type === 'raw' ? 'Raw' : 'Component';
                
                const productRow = $(`
                    <tr data-product-id="${product.id}">
                        <td>${product.code}</td>
                        <td>${product.name}</td>
                        <td><span class="badge bg-secondary">${typeLabel}</span></td>
                        <td>$${product.cost_price}</td>
                        <td>$${product.sale_price}</td>
                        <td><span class="${stockClass}">${product.available_quantity}</span></td>
                        <td>${product.unit_of_measure}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary edit-product-btn">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm btn-outline-danger delete-product-btn">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `);
                
                productRow.find('.edit-product-btn').click(function() {
                    showEditProductModal(product.id);
                });
                
                productRow.find('.delete-product-btn').click(function() {
                    showDeleteConfirmModal(product.id);
                });
                
                $('#product-table-body').append(productRow);
            });
        } else {
            $('#empty-products-table').show();
        }
    }
    
    // Show create product modal
    function showCreateProductModal() {
        $('#product-modal-title').text('Create New Product');
        $('#product-id').val('');
        $('#product-form')[0].reset();
        $('#product-form-modal').modal('show');
    }
    
    // Show edit product modal
    function showEditProductModal(productId) {
        currentProductId = productId;
        
        // In a real app, you would fetch the product data via AJAX

        
        const product = mockProducts.find(p => p.id == productId);
        if (product) {
            $('#product-modal-title').text('Edit Product');
            $('#product-id').val(product.id);
            $('#product-name').val(product.name);
            $('#product-code').val(product.code);
            $('#product-type').val(product.product_type);
            $('#product-uom').val(product.unit_of_measure);
            $('#product-cost').val(product.cost_price);
            $('#product-sale').val(product.sale_price);
            $('#product-quantity').val(product.available_quantity);
            $('#product-form-modal').modal('show');
        }
    }
    
    // Save product (create or update)
    function saveProduct() {
        const form = $('#product-form')[0];
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }
        
        const productData = {
            id: $('#product-id').val(),
            name: $('#product-name').val(),
            code: $('#product-code').val(),
            product_type: $('#product-type').val(),
            unit_of_measure: $('#product-uom').val(),
            cost_price: $('#product-cost').val(),
            sale_price: $('#product-sale').val(),
            available_quantity: $('#product-quantity').val()
        };
        
        // In a real app, this would be an AJAX call to your Django backend
        console.log('Saving product:', productData);
        
        // Simulate success
        $('#product-form-modal').modal('hide');
        loadProducts(); // Refresh the list
        
        if (productData.id) {
            showToast('Product updated successfully!', 'success');
        } else {
            showToast('Product created successfully!', 'success');
        }
    }
    
    // Show delete confirmation modal
    function showDeleteConfirmModal(productId) {
        currentProductId = productId;
        $('#delete-confirm-modal').modal('show');
    }
    
    // Delete product
    function deleteProduct() {
        $('#delete-confirm-modal').modal('hide');
        
        // In a real app, this would be an AJAX call to your Django backend
        console.log('Deleting product:', currentProductId);
        
        // Simulate success
        currentProductId = null;
        loadProducts(); // Refresh the list
        showToast('Product deleted successfully!', 'success');
    }
    
    // Filter products
    function filterProducts() {
        const searchTerm = $('#product-search').val().toLowerCase();
        const typeFilter = $('#type-filter').val();
        const stockFilter = $('#stock-filter').val();
        
        // In a real app, this would be an AJAX call with filters
        // For demo, we'll just filter the existing mock data
        
        
        const filteredProducts = mockProducts.filter(product => {
            const matchesSearch = searchTerm === '' || 
                                product.name.toLowerCase().includes(searchTerm) || 
                                product.code.toLowerCase().includes(searchTerm);
            
            const matchesType = typeFilter === '' || product.product_type === typeFilter;
            
            let matchesStock = true;
            if (stockFilter === 'in_stock') {
                matchesStock = product.available_quantity > 10;
            } else if (stockFilter === 'low_stock') {
                matchesStock = product.available_quantity > 0 && product.available_quantity <= 10;
            } else if (stockFilter === 'out_of_stock') {
                matchesStock = product.available_quantity <= 0;
            }
            
            return matchesSearch && matchesType && matchesStock;
        });
        
        renderProductGrid(filteredProducts);
        renderProductTable(filteredProducts);
    }
    
    // Helper function to get stock status class
    function getStockClass(quantity) {
        if (quantity <= 0) return 'out-of-stock';
        if (quantity <= 10) return 'low-stock';
        return 'in-stock';
    }
    
    // Helper function to format date
    function formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString();
    }
    
    // Helper function to show toast messages
    function showToast(message, type = 'success') {
        // In a real app, you would use a proper toast library
        alert(`${type.toUpperCase()}: ${message}`);
    }
    


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
          $("#product-form-modal").modal("show");
        },
        success: function (data) {
          

          $("#product-form-modal .modal-content").html(data.html_product_form);


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
           $("#product-form-modal").modal("hide");
           loadProducts();

            console.log("success");
         }
         else {

           $("#company-table tbody").html(data.html_assetFailure_list);
           $("#modal-company .modal-content").html(data.html_assetFailure_form);
         }
       }
     });
     return false;
   };


   var myWoLoader= function(){
     btn=$(this);



     loadForm(btn);

   }


   $('#search').pDatepicker({
    format: 'YYYY-MM-DD',
    autoClose: true,
    initialValueType: 'gregorian',
    calendar:{
      persian: {
          leapYearMode: 'astronomical'
      }
  },
  });
  var delete_asset_failure=function(){
     swal({
         title: "مطمئن هستید؟",
         text: "",
         icon: "warning",
         buttons: true,
         dangerMode: true,
     })
         .then((willDelete) => {
             if (willDelete) {
                 swal("اوه!  حذف شد!", {
                     icon: "success",
                 });
             } else {
                 swal("فایل شما هنوز وجود دارد !", {
                     icon: "error",
                 });
             }
         });

}

  $("#create-product-btn").click(myWoLoader);
  $("#product-form-modal").on("submit", ".js-product-create-form", saveForm);

  // Update book
  $("#company-table").on("click", ".js-update-failure", myWoLoader);
  $("#modal-company").on("submit", ".js-failure-update-form", saveForm);
  // Delete book
  $("#company-table").on("click", ".js-failure-delete", myWoLoader);
  $("#modal-company").on("submit", ".js-failure-delete-form", saveForm);
  });
