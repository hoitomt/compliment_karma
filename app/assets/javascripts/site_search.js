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
	},
	searchFx: function() {
		var searchString = $('input#search_string').val();
		var results = SiteSearch.ajaxSearch(searchString);
		if(searchString.length == 0) {
			SiteSearch.hideResults();
		} else if(results && results.length > 0) {
			SiteSearch.showResults(results, searchString);
		} else {
			SiteSearch.hideResults();
		}
	},
	showResults: function(results, searchString) {
		var displayResults = SiteSearch.formatResults(results, searchString);
		$('#site-search-results').html(displayResults);
		SiteSearch.setResultClickHandlers();
		$('#site-search').show();
	},
	hideResults: function() {
		$('#site-search').hide();
	},
	ajaxSearch: function(searchString) {
		$.ajax({
			url: '/search/site',
			data: {'search_string' : searchString}
		});
	},
	formatResults: function(results, searchString) {
		var result = '<ul id="register-me">';
		$.each(results, function(i, val) {
			valString = val.first_name + " " + val.last_name + "<br />" + val.city;
			var formattedResult = SiteSearch.highlightSearchString(valString, searchString);
			var link = '<a href="/users/' + val.id + '">';
			result += "<li>" + link + formattedResult + "</a></li>";
		})
		result += "</ul>";
		return result;
	},
	highlightSearchString: function(result, searchString) {
		if( result == null || result == undefined || 
				searchString == null || searchString == undefined) {
			return;
		}
		var length = searchString.length;
		var start = result.toLowerCase().indexOf(searchString.toLowerCase());
		var replaceMe = result.substring(start, start + length);
		var formattedResult = result.replace(replaceMe, '<strong>' + replaceMe + '</strong>');
		return formattedResult;
	},
	setResultClickHandlers: function() {
		$('#register-me').off('click');
		$('#register-me').on({
			click: function() {
				var value = $(this).html();
				console.log(value);
				window.location.href = $(value).attr('href');
				SiteSearch.hideResults();
			}
		}, 'li')
	}
}