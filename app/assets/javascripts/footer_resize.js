var FooterResize = {
	init: function() {
		var viewportHeight = $.waypoints('viewportHeight');
		var headerHeight = $('#header').height();
		var mainContainerHeight = $('#main-container').height();
		var footerHeight = $('#footer').height();
		var contentHeight = headerHeight + mainContainerHeight + footerHeight;
		var delta = viewportHeight - contentHeight;
		console.log("Header Height: " + headerHeight + 
								"| Main Container Height: " + mainContainerHeight +
								"| Footer Height: " + footerHeight + 
								"| View port height: " + viewportHeight);
		if(delta > 0) {
			$('#expansion-div').height(delta);
		} else {
			$('#expansion-div').height(0);
		}
	}
	
}