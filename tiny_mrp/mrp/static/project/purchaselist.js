$(function () {
    var loadForm =function (btn1) {
        var btn=0;
        btn=btn1;
        return $.ajax({
          url: btn1,
          type: 'get',
          dataType: 'json',
          beforeSend: function () {
            
          },
          success: function (data) {
            //alert("3123@!");
            $(".ajax-content").html(data.parchase_req_html);
            $("#purchase_tab_card").html(data.parchase_req_tab);
            // console.log($("#purchase_tab_card"));
            $("#update_tab2").removeClass( "d-none" )
            $(".main_slidebar").addClass("d-none");

            feather.replace();
            // new Quill('.compose-quill-editor', {
            //     modules: {
            //         toolbar: ".compose-quill-toolbar"
            //     },
            //     placeholder: "اینجا بنویسید...",
            //     theme: "snow"
            // });
            
            // new Quill('.reply-email-quill-editor', {
            //     modules: {
            //         toolbar: ".reply-email-quill-toolbar"
            //     },
            //     placeholder: "اینجا بنویسید...",
            //     theme: "snow"
            // });
            
            

    
          }
        });
    
    
    
    };
    var add_viewer=function(id){
        $.ajax({
            url: '/Purchases/AddViewer/?id='+id,  // The URL of your API endpoint
            type: 'GET',  // Using GET method to retrieve data
            dataType: 'json',  // The expected data format from the server
            success: function(response) {
                // This function is executed if the request is successful
                console.log('Success:', response);
                // You can use the response here, e.g., update the DOM or process the data
            },
            error: function(xhr, status, error) {
                // This function is executed if there is an error with the request
                console.error('Error:', status, error);
                // You can display an error message or handle the failure
            }
        });
        
    }
    function refreshList2() {
        const currentParams = new URLSearchParams(window.location.search);

        // Save them globally for later use
        const filters = {};
        for (const [key, value] of currentParams.entries()) {
            filters[key] = value;
        }
        // Send the query parameters with the list reload request
        const params = new URLSearchParams(filters).toString();
    
        $.ajax({
            url: `/Purchases/RefereshList?${params}`, // Append filters to the URL
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
    var confirm_request=function(url){
        return $.ajax({
            url: url,
            type: 'get',
            dataType: 'json',
            beforeSend: function () {
             
            },
            success: function (data) {
                console.log(data.http_status);
              
              if(data.http_status=="ok"){
                $(".badge_status").html(data.status);
                refreshList2();
                // $("#main_ul").html(data.parchase_req_html);


              }
              if(data.http_status=="error"){
                toastr.error(data.message);
                

              }
              
              
              
  
      
            }
          });

    }
    var reject_request=function(url){
        return $.ajax({
            url: url,
            type: 'get',
            dataType: 'json',
            beforeSend: function () {
             
            },
            success: function (data) {
              
              if(data.http_status=="ok"){
                $(".badge_status").html(data.status);
                // $("#main_ul").html(data.parchase_req_html);
                refreshList2();

              }
            //   feather.replace();
              
              
              
  
      
            }
          });

    }
    var delete_request=function(url){
        return $.ajax({
            url: url,
            type: 'POST',
            dataType: 'json',
            beforeSend: function () {
             
            },
            success: function (data) {
              
              if(data.http_status=="ok"){
                // $(".badge_status").html(data.status);
                $("#main_ul").html(data.parchase_req_html);
                if(data.message){
                    swal(data.message, {
                        icon: "warning",
                    });
                    
                }
                else{
                    swal("با موفقیت حدف شد", {
                        icon: "success",
                    });
                    
                }
               
              }
            //   feather.replace();
              
              
              
  
      
            }
          });

    }
    
    $(document).on('click', '.app-block .app-content .app-action .action-left input[type="checkbox"]', function () {
        $('.app-lists ul li input[type="checkbox"]').prop('checked', $(this).prop('checked'));
        if ($(this).prop('checked')) {
            $('.app-lists ul li input[type="checkbox"]').closest('li').addClass('active');
        } else {
            $('.app-lists ul li input[type="checkbox"]').closest('li').removeClass('active');
        }
    });

    $(document).on('click', '.app-lists ul li input[type="checkbox"]', function () {
        if ($(this).prop('checked')) {
            $(this).closest('li').addClass('active');
        } else {
            $(this).closest('li').removeClass('active');
        }
    });

    $(document).on('click', '.app-block .app-content .app-content-body .app-lists ul.list-group li.list-group-item', function (e) {
        btn=$(this);
        if (!$(e.target).is('.custom-control, .custom-control *, a, a *')) {
            $('.app-detail').addClass('show').one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function () {
                $('.app-block .app-content .app-content-body .app-detail .app-detail-article').niceScroll().resize();
                loadForm(btn.attr("data-url"));
                add_viewer(btn.attr("data-id"));
                btn.addClass('active');
               
            });
        }
    });
    $(document).on('click', '.btn-block2', function (e) {
        if (!$(e.target).is('.custom-control, .custom-control *, a, a *')) {
            $('.app-detail').addClass('show').one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function () {
                loadForm($("#createreq").attr("data-url"));
                $('.app-block .app-content .app-content-body .app-detail .app-detail-article').niceScroll().resize();
               
            });
        }
    });

    $(document).on('click', 'a.app-detail-close-button', function () {
        $('.app-detail').removeClass('show');
        $(".main_slidebar").removeClass( "d-none" );
        $("#update_tab2").addClass("d-none");
        // $(".main_slidebar").addClass( "show" )

        // لود کردن اطلاعات بروز شده
        return false;
    });

    $(document).on('click', '.app-sidebar-menu-button', function () {
        $('.app-block .app-sidebar, .app-content-overlay').addClass('show');
        // $('.app-block .app-sidebar .app-sidebar-menu').niceScroll().resize();
        return false;
    });

    $(document).on('click', '.app-content-overlay', function () {
        $('.app-block .app-sidebar, .app-content-overlay').removeClass('show');
        
        return false;
    });
    $(document).on('click', '.approved, .confirm-purchase-request', function () {
        url=$(this).attr("data-url");
        confirm_request(url);     
        $(this).hide();
        return false;
    });
    $(document).on('click', '.rejected', function () {
        url=$(this).attr("data-url");
        reject_request(url);     
        $(this).hide();
        return false;
    });
    $(document).on('click', '.btn-block3', function () {
        console.log('clicked');

        var currentUrl = new URL(window.location.href);
        var baseUrl = "/Purchase/Download";  // Django URL tag
    
        // Initialize an empty query string
        var queryParams = "";
    
        // Check if the current URL has query parameters and add them to the redirection URL
        var sortBy = currentUrl.searchParams.get("sort_by");
        var status = currentUrl.searchParams.get("status");
        var searchQuery = currentUrl.searchParams.get("q");
        var start = currentUrl.searchParams.get("start");
        var end = currentUrl.searchParams.get("end");
        var userlist = currentUrl.searchParams.get("userlist");
    
        // Add `sort_by` parameter if it exists in the URL
        if (sortBy) {
            queryParams += "?sort_by=" + encodeURIComponent(sortBy);
        }
    
        // Add `status` parameter if it exists in the URL
        if (status) {
            queryParams += (queryParams ? "&" : "?") + "status=" + encodeURIComponent(status);
        }
    
        // Add `q` parameter if it exists in the URL
        if (searchQuery) {
            queryParams += (queryParams ? "&" : "?") + "q=" + encodeURIComponent(searchQuery);
        }
        if (start) {
            queryParams += (queryParams ? "&" : "?") + "start=" + encodeURIComponent(start);
        }
        if (end) {
            queryParams += (queryParams ? "&" : "?") + "end=" + encodeURIComponent(end);
        }
        if (userlist) {
            queryParams += (queryParams ? "&" : "?") + "userlist=" + encodeURIComponent(userlist);
        }
        console.log(queryParams);
    
        // Redirect to the generated URL
        document.location = baseUrl + queryParams;
    });
    $(document).on('click', '.delete-purchase-request', function () {
        url=$(this).attr("data-url");
        // reject_request(url);     
        // $(this).hide();
        // return false;
        swal({
            title: "مطمئن هستید؟",
            text: "در صورت حدف درخواست عملیات بازگردانی مقدور نخواهد بود!",
            icon: "warning",
            buttons: true,
            dangerMode: true,
        })
            .then((willDelete) => {
            if (willDelete) {
                delete_request(url);
                $('.app-detail').removeClass('show');


                
            } 
            else {
               
        }
            });
    
        
    });


    function addImageInput() {
        const inputGroup = `
          <div class="input-group mb-2">
            <input type="file" name="file" accept="image/*" class="form-control" required>
            <button type="button" class="btn btn-danger remove-btn">حذف</button>
          </div>`;
        $('#image-container').append(inputGroup);
      }
  
      // Add the first input field by default
      addImageInput();
  
      // Handle "Add Image" button click
      $(document).on('click','#add-image-btn', function () {
        addImageInput();
      });
  
      // Handle dynamic "Remove" button click
      $(document).on('click', '#image-container .remove-btn', function () {
        $(this).closest('.input-group').remove();
      });
  
      // Handle form submission (for debugging)
    //   $('#image-upload-form').on('submit', function (e) {
    //     e.preventDefault();
    //     const formData = new FormData(this);
    //     for (let [key, value] of formData.entries()) {
    //       console.log(key, value.name); // Logs the uploaded file names
    //     }
    //     alert('فرم ارسال شد!');
    //   });
    
   
});

