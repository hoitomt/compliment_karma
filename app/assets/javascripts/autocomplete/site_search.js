var SiteSearch = {
	init: function() {
		this.registerHandler();
	},
	registerHandler: function() {
		$('input#search_string').off('keyup');
		$('input#search_string').on({
			keyup: function(event) {				
				// Don't search if an arror key, enter(13), shift (9), or tab(16) is selected
				if(event.keyCode != 37 && event.keyCode != 38 && 
					 event.keyCode != 39 && event.keyCode != 40 && 
					 event.keyCode != 13 && event.keyCode != 16 &&
					 event.keyCode != 9 && ComplimentReceiver.performSearch) {
					setTimeout("SiteSearch.searchFx()", 400);
				}
				event.stopPropagation();
			}
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