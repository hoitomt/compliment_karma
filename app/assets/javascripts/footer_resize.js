var FooterResize = {
	init: function() {
		// distance of footer from top of DOM + the height of the footer
		var footerBottom = $('#footer').offset().top + $('#footer').height();
		var documentBottom = $(document).height();
		console.log(footerBottom + '|' + documentBottom);
		if(footerBottom && footerBottom < documentBottom && $('#footer').is(":visible")) {
			var mainHeight = $('.main').height();
			if(mainHeight && mainHeight > 0) {
				$('.main').height(mainHeight + (documentBottom-footerBottom));
			} else {
				var expansionHeight = $('#expansion-div').height();
				var delta = documentBottom - footerBottom;
				var newHeight = expansionHeight + delta;
				console.log(expansionHeight + '|' + newHeight);
				$('#expansion-div').height(newHeight);
			}
		}
	}
	
}