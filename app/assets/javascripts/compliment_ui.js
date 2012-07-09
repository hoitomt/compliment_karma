var ComplimentUI = {
	init: function() {
		this.setNewComplimentHandlers();
	},
	flashBlue: function() {
		$('#new-compliment').effect("highlight", {color: "#006791"}, 2500);
	},
	setNewComplimentHandlers: function() {
		$('input#compliment_receiver_email').off('click');
		$('input#compliment_receiver_email').click(function() {
			$('.hide-me').slideDown();
		});
		$('#minimize-me').off('click');
		$('#minimize-me').click(function() {
			$('.hide-me').slideUp();
		});
		$('#new-compliment-container').off('blur');
		$('#new-compliment-container').click(function(event) {
			event.stopPropagation();
		});
		$('html').click(function() {
			$('.hide-me').slideUp();
		})
	}
}