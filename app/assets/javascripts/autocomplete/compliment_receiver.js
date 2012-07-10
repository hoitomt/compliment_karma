var ComplimentReceiver = {
	init: function() {
		this.registerHandler();
	},
	registerHandler: function() {
		$('input#compliment_receiver').unbind('input');
		$('input#compliment_receiver').bind('input', function(event) {
			setTimeout("ComplimentReceiver.searchFx()", 400);
			event.stopPropagation();
		});
		$('html').click(function() {
			ComplimentReceiver.hideResults();
		});
	},
	searchFx: function() {
		var searchString = $('input#compliment_receiver').val();
		var results = ComplimentReceiver.ajaxSearch(searchString);
	},
	hideResults: function() {
		$('#compliment-receiver-results-container').hide();
	},
	ajaxSearch: function(searchString) {
		$.ajax({
			url: '/search/compliment_receiver.js',
			data: {'search_string' : searchString}
		});
	}
}