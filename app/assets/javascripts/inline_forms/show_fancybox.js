var ShowFancybox = {
	init: function(options) {
		console.log("Init Fancybox");
		if(options.width == null) {
			options.width = 0;
		}
		if(options.source && options.source == "confirmation") {
			this.displayFancyBoxReloadClose(options);
		} else {
			this.displayFancyBox(options);
		}
	},
	displayFancyBox: function(options) {
		$.fancybox(options.view, {
			beforeLoad: function() {
				$('body').addClass('lock-screen');
			},
			beforeClose: function() {
				$('body').removeClass('lock-screen');
			},
			minWidth: options.width,
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
	},
	displayFancyBoxReloadClose: function(options) {
		console.log("Dfbrc");
		$.fancybox(options.view, {
			beforeLoad: function() {
				$('body').addClass('lock-screen');
			},
			beforeClose: function() {
				$('body').removeClass('lock-screen');
        window.location.href = 'http://localhost:3000/users/' + userId;
			},
			afterClose: function() {
				// UserConfirmation.init(options.redirectView);
        // window.location.href = 'http://localhost:3000/users/' + userId;
			},
			minWidth: options.width,
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