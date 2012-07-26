var ShowFancybox = {
	init: function(view, width) {
		if(width == null) {
			width = 0;
		}
		$.fancybox(view, {
			beforeLoad: function() {
				// $('body').addClass('lock-screen');
			},
			beforeClose: function() {
				// $('body').removeClass('lock-screen');
			},
			fitToView: false,
			scrolling: 'no',
			autoSize: true,
			minWidth: width,
			padding: 0,
			helpers: {
				overlay: {
					css: {
						'background-color': '#A7DBD8'
					}
				},
				title: null
			}
		});
	}
}