function SiteSearch(el, source) {
	this.$el = $(el);
	this.source = source;
	this.bindEvents();
}

SiteSearch.prototype.bindEvents = function() {
	var ssObj = this;
	this.$el.off('keyup');
	this.$el.on({
		keyup: function(event) {				
			// Don't search if an arror key, enter(13), shift (9), or tab(16) is selected
			if(event.keyCode != 37 && event.keyCode != 38 && 
				 event.keyCode != 39 && event.keyCode != 40 && 
				 event.keyCode != 13 && event.keyCode != 16 &&
				 event.keyCode != 9 && ComplimentReceiver.performSearch) {
				var searchIt = ssObj.searchFx();
				setTimeout(searchIt, 400);
			}
			event.stopPropagation();
		}
	});
	$('html').click(function() {
		ssObj.hideResults();
	});
	$('#search-icon').off('click');
	$('#search-icon').on({
		click: function() {
			var searchString = ssObj.$el.val();
			window.location.href = '/search/site?search_string=' + searchString;
		}
	});
}

SiteSearch.prototype.searchFx = function() {
	var searchString = this.$el.val();
	var results = this.ajaxSearch(searchString, this.source);
}

SiteSearch.prototype.hideResults = function() {
	$('#site-search').hide();
}

SiteSearch.prototype.ajaxSearch = function(searchString, source) {
	$.ajax({
		url: '/search/site.js',
		data: {'search_string' : searchString, 'source' : source}
	});
}

SiteSearch.prototype.retrieveUser = function(userId) {
	var userPath = '/users/' + userId.toString();
	window.location.href = userPath;
}

SiteSearch.resetContactSearch = function() {
	var searchField = $('#new-contact-form').find('#search_string');		
	$(searchField).val('');
	$('#flash-narrow').hide();
	$container = $('#contact-search');
	$container.html('');
}

SiteSearch.hideResults = function() {
	$('#site-search').hide();
}

SiteSearch.retrieveUser = function(userId) {
	var userPath = '/users/' + userId.toString();
	window.location.href = userPath;
}


// var SiteSearch = {
// 	$searchField: null,
// 	source: null,
// 	init: function(searchField, source) {
// 		this.$searchField = $(searchField);
// 		this.source = source;
// 		this.registerHandler();
// 	},
// 	registerHandler: function() {
// 		console.log(SiteSearch.$searchField);
// 		SiteSearch.$searchField.off('keyup');
// 		SiteSearch.$searchField.on({
// 			keyup: function(event) {				
// 				// Don't search if an arror key, enter(13), shift (9), or tab(16) is selected
// 				if(event.keyCode != 37 && event.keyCode != 38 && 
// 					 event.keyCode != 39 && event.keyCode != 40 && 
// 					 event.keyCode != 13 && event.keyCode != 16 &&
// 					 event.keyCode != 9 && ComplimentReceiver.performSearch) {
// 					setTimeout("SiteSearch.searchFx()", 400);
// 				}
// 				event.stopPropagation();
// 			}
// 		});
// 		$('html').click(function() {
// 			SiteSearch.hideResults();
// 		});
// 		$('#search-icon').off('click');
// 		$('#search-icon').on({
// 			click: function() {
// 				var searchString = SiteSearch.$searchField.val();
// 				window.location.href = '/search/site?search_string=' + searchString;
// 			}
// 		});
// 	},
// 	searchFx: function() {
// 		var $newContactForm = $('.new-contact-input');
// 		var searchString = SiteSearch.$searchField.val();
// 		// var source = 'main';
// 		// if($newContactForm.is(':visible')) {
// 		// 	var inputField = $newContactForm.find('input#search_string');
// 		// 	searchString = $(inputField).val();
// 		// 	source = 'new-contact'
// 		// }
// 		var results = SiteSearch.ajaxSearch(searchString, SiteSearch.source);
// 	},
// 	hideResults: function() {
// 		$('#site-search').hide();
// 	},
// 	ajaxSearch: function(searchString, source) {
// 		$.ajax({
// 			url: '/search/site.js',
// 			data: {'search_string' : searchString, 'source' : source}
// 		});
// 	},
// 	retrieveUser: function(userId) {
// 		var userPath = '/users/' + userId.toString();
// 		window.location.href = userPath;
// 	},
// 	resetContactSearch: function() {
// 		var searchField = $('#new-contact-form').find('#search_string');		
// 		$(searchField).val('');
// 		$('#flash-narrow').hide();
// 		$container = $('#contact-search');
// 		$container.html('');
// 	}
// }