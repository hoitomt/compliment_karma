var FooterResize = {
	init: function() {
		var viewportHeight = $.waypoints('viewportHeight');
		var headerHeight = $('#header').height();
		var mainContainerHeight = $('#main-container').height();// + 20; //padding
		var footerHeight = $('#footer').height();
		var footerVisible = $('#footer').is(':visible');
		var contentHeight = headerHeight + mainContainerHeight + footerHeight;
		var delta = viewportHeight - contentHeight;
		// console.log("Header Height: " + headerHeight + 
		// 						"| Main Container Height: " + mainContainerHeight +
		// 						"| Footer Height: " + footerHeight + 
		// 						"| Content Height: " + contentHeight +
		// 						"| View port height: " + viewportHeight +
		// 						"| Delta: " + delta +
		// 						"| Footer Visible: " + footerVisible);
		if(delta > 0 && footerVisible) {
			$('#expansion-div').height(delta);
		} else {
			$('#expansion-div').height(0);
		}
	}
	
}