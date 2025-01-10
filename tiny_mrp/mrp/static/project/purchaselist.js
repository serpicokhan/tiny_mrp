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
    var confirm_request=function(url){
        return $.ajax({
            url: url,
            type: 'get',
            dataType: 'json',
            beforeSend: function () {
             
            },
            success: function (data) {
              
              if(data.http_status=="ok"){
                $(".badge_status").html(data.status);
                $("#main_ul").html(data.parchase_req_html);

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
                $("#main_ul").html(data.parchase_req_html);
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
    $(document).on('click', '.aproved', function () {
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

