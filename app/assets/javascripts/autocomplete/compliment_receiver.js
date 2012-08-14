var ComplimentReceiver = {
	performSearch: true,
	init: function() {
		this.registerHandler();
	},
	setPerformSearch: function(s) {
		this.performSearch = s;
	},
	registerHandler: function() {
		$('input#compliment_receiver_display').off('keyup');
		$('input#compliment_receiver_display').on({
			keyup: function(event) {
				// Don't search if an arror key, enter(13), shift (9), or tab(16) is selected
				// console.lot(event.keyCode);
				if(event.keyCode != 37 && event.keyCode != 38 && 
					 event.keyCode != 39 && event.keyCode != 40 && 
					 event.keyCode != 13 && event.keyCode != 16 &&
					 event.keyCode != 9 && ComplimentReceiver.performSearch) {
					$('#compliment_receiver_id').val('');
					setTimeout("ComplimentReceiver.searchFx()", 400);
				}
				// Start Search again if backspace, delete, or v (as in Control-v) is hit
				if(event.keyCode == 8 || event.keyCode == 91 ||
					 event.keyCode == 86 || $('#compliment_receiver_id').val().length == 0) {
					ComplimentReceiver.performSearch = true;
				}
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