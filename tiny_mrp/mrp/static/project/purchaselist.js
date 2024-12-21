$(function () {
    var loadForm =function (btn1) {
        var btn=0;
        //console.log(btn1);
        // if($(btn1).attr("type")=="click")
        //  btn=$(this);
        // else {
        //   btn=btn1;
        // }
        btn=btn1;
        //console.log($(btn).attr("type"));
        console.log(btn);
        return $.ajax({
          url: btn1,
          type: 'get',
          dataType: 'json',
          beforeSend: function () {
            //alert(btn.attr("data-url"));
            //alert("321321");
            // /$("#modal-maintenanceType").modal("hide");
            // $("#modal-company").modal("show");
          },
          success: function (data) {
            //alert("3123@!");
            $(".ajax-content").html(data.parchase_req_html);
            feather.replace();
            new Quill('.compose-quill-editor', {
                modules: {
                    toolbar: ".compose-quill-toolbar"
                },
                placeholder: "اینجا بنویسید...",
                theme: "snow"
            });
            
            new Quill('.reply-email-quill-editor', {
                modules: {
                    toolbar: ".reply-email-quill-toolbar"
                },
                placeholder: "اینجا بنویسید...",
                theme: "snow"
            });
            
            

    
          }
        });
    
    
    
    };
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
                console.log($(this));
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
});