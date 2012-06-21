var ShowRecognitionFancyBox = {
	init: function(view, socialPopup) {
		$.fancybox(view, {
			beforeLoad: function() {
				$('body').addClass('lock-screen');
				this.title = String(socialPopup);
			},
			afterShow: function() {
				UserProfile.reinitialize();
			},
			beforeClose: function() {
				$('body').removeClass('lock-screen');
			},
			minWidth: 590,
			helpers: {
				overlay: {
					css: {
						'background-color': '#A7DBD8'
					}
				},
				title: {
					type: 'float',
					css: {
						'width': '10px'
					}
				}
			}
		});
	}
}
