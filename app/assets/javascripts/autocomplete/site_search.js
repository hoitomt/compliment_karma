var SiteSearch = {
	init: function() {
		this.registerHandler();
	},
	registerHandler: function() {
		$('input#search_string').unbind('input');
		$('input#search_string').bind('input', function(event) {
			setTimeout("SiteSearch.searchFx()", 400);
			event.stopPropagation();
		});
		$('html').click(function() {
			SiteSearch.hideResults();
		});
		$('#search-icon').off('click');
		$('#search-icon').on({
			click: function() {
				var searchString = $('input#search_string').val();
				window.location.href = '/search/site?search_string=' + searchString;
			}
		});
	},
	searchFx: function() {
		var searchString = $('input#search_string').val();
		var results = SiteSearch.ajaxSearch(searchString);
	},
	hideResults: function() {
		$('#site-search').hide();
	},
	ajaxSearch: function(searchString) {
		$.ajax({
			url: '/search/site.js',
			data: {'search_string' : searchString}
		});
	},
	retrieveUser: function(userId) {
		var userPath = '/users/' + userId.toString();
		window.location.href = userPath;
	}
}