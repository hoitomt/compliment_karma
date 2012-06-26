var AutoComplete = {
	closeAllWindows: function() {
		$('#site-search').bind('closeWindows', function(d) {
			console.log("closeWindows Event");
			this.hide();
		});
	}
}