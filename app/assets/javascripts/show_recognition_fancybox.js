var ShowRecognitionFancyBox = {
	init: function(view, socialPopup, userId) {
		console.log(socialPopup);
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
				if(userId != null && userId > 0) {
					window.location.href = 'http://www.complimentkarma.com/users/' + userId;
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
