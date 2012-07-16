var FooterResize = {
	init: function() {
		var viewportHeight = $.waypoints('viewportHeight');
		var footerHeight = $('#footer').height();
		var footerTop = $('#footer').offset().top;
		var footerBottom = $('#footer').offset().top + footerHeight;
		var mainContainerBottom = $('#main-container').offset().top + $('#main-container').height();
		console.log("Footer Bottom: " + footerBottom + 
			'| View Port Height: ' +  viewportHeight +
			'| Main Container Bottom: ' + mainContainerBottom);
		if(footerBottom < mainContainerBottom) {
			// The page is missing the footer
			return;
		}
		if(viewportHeight > footerBottom) {
			var delta = viewportHeight - footerBottom;
			var mainContainerHeight = $('#main-container').height()
			$('#expansion-div').height(delta);
		}

		// var documentBottom = $(document).height();
		// // console.log(footerBottom + '|' + documentBottom);
		// if(footerBottom && footerBottom < documentBottom && $('#footer').is(":visible")) {
		// 	var mainHeight = $('#main-container').height();
		// 	if(mainHeight && mainHeight > 0) {
		// 		$('#main-container').height(mainHeight + (documentBottom-footerBottom));
		// 	} else {
		// 		// var expansionHeight = $('#expansion-div').height();
		// 		var delta = documentBottom - footerBottom;
		// 		// var newHeight = expansionHeight + delta;
		// 		// console.log(expansionHeight + '|' + newHeight);
		// 		$('#expansion-div').height(delta);
		// 		// $('#expansion-div').height(newHeight);
		// 	}
		// }
	}
	
}