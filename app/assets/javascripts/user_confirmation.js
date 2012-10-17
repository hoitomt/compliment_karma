var UserConfirmation = {
  init: function(view) {
    // $.fancybox.close(true);
    this.showFancybox(view);
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
  }

}