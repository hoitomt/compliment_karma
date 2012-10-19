var ShowFancybox = {
	init: function(options) {
		console.log("Init Fancybox");
		if(options.width == null) {
			options.width = 0;
		}
		this.displayFancyBox(options);
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
	}
}