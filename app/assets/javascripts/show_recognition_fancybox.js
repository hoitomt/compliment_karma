var ShowRecognitionFancyBox = {
	init: function(options) {
		var userId = options.userId;
		var socialPopup = options.socialPopup;
		var redirectOnClose = options.redirectOnClose;
		var view = options.view;

		$.fancybox(view, {
			beforeLoad: function() {
				$('body').addClass('lock-screen');
				this.title = socialPopup;// String(socialPopup);
			},
			afterShow: function() {
				UserProfile.reinitialize();
			},
			beforeClose: function() {
				$('body').removeClass('lock-screen');
			},
			afterClose: function() {
				if(redirectOnClose) {
					window.location.href = 'http://www.complimentkarma.com';
				}
			},
			// fitToView: false,
			// scrolling: 'no',
			// autoSize: true,
			minWidth: 680,
			padding: 10,
			helpers: {
				overlay: {
					css: {
						'background-color': '#A7DBD8'
					}
				}//,
				// title: {
				// 	// type: 'float',
				// 	css: {
				// 		'width': '600px'
				// 	}
				// }
			}
		});
	}
}
