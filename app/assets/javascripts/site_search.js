var SiteSearch = {
	init: function() {
		$('#search-icon').click(function(event) {
			$('#menu-bar-search-form').submit();
		});
	}
}