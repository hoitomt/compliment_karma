var UserConfirmation = {
  init: function(view) {
    this.showFancybox(view);
    var $slideDiv = $('#email-address');
    this.setClickHandlers($slideDiv);
  },
  showFancybox: function(view) {
    $.fancybox(view, {
      beforeShow: function() {
        $(".fancybox-skin").css("backgroundColor", "#A7DBD8");
      },
      // minWidth: 600,
      // padding: 0,
      modal: true,
      helpers: {
        overlay: {
          css: {
            // 'background-color': '#ffffff'
            'background': 'rgba(240, 240, 240, 0.75)'
          }
        },
        title: null
      }
    });
  },
  setClickHandlers: function($slideDiv) {
    $('#change-email').click(function() {
      if($slideDiv.is(':visible')) {
        $slideDiv.slideUp();
      } else {
        $slideDiv.slideDown();
      }
    })
  }
}