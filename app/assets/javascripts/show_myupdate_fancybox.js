var ShowMyUpdateFancyBox = {
	init: function(view, socialPopup) {
		$.fancybox(view, {
			beforeLoad: function() {
				$('body').addClass('lock-screen');
				this.title = socialPopup;
			},
			afterShow: function() {
				UserProfile.reinitialize();
			},
			beforeClose: function() {
				$('body').removeClass('lock-screen');
			},
			minWidth: 550,
			minHeight: 50,	
			topRatio: 0,
			padding: 0,
			helpers: {
				overlay: {
					css: {
						'background': 'none'
					}
				}
			}
		});
	}
}