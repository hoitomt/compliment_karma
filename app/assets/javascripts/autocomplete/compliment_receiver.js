var ComplimentReceiver = {
	init: function() {
		this.registerHandler();
	},
	registerHandler: function() {
		$('input#compliment_receiver_display').off('keyup');
		$('input#compliment_receiver_display').on({
			keyup: function(event) {
				// $('#compliment_receiver_id').val('');
				setTimeout("ComplimentReceiver.searchFx()", 400);
				event.stopPropagation();
			}
		});
		$('html').click(function() {
			ComplimentReceiver.hideResults();
		});
	},
	searchFx: function() {
		var searchString = $('input#compliment_receiver_display').val();
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