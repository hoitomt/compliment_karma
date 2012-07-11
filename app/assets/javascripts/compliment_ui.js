var ComplimentUI = {
	userId: 0,
	init: function(userId) {
		this.userId = userId
		this.setNewComplimentHandlers();
		this.stickyNewCompliment();
	},
	flashBlue: function() {
		$('#new-compliment').effect("highlight", {color: "#006791"}, 2500);
	},
	setNewComplimentHandlers: function() {
		$('input#compliment_receiver').off('click, change');
		$('input#compliment_receiver').click(function() {
			ComplimentUI.showNewComplimentPanel();
			// event.stopPropagation();
		});
		$('#minimize-me').off('click');
		$('#minimize-me').click(function() {
			ComplimentUI.hideNewComplimentPanel();
		});
		$('#new-compliment-container').off('click');
		$('#new-compliment-container').click(function(event) {
			event.stopPropagation();
		});
		$('html').click(function(event) {
			var isAnchor = $(event.srcElement).is('a');
			// var isInContainer = $(event.srcElement).parents('#new-compliment-container');
			// console.log(isInContainer);
			if(!isAnchor/* && !isInContainer*/) {
				ComplimentUI.hideNewComplimentPanel();
			}
		});
		$('input#compliment_receiver').blur(function(userId) {
			ComplimentUI.validateSenderNotReceiver();
		})
	},
	showNewComplimentPanel: function() {
		$('.hide-me').slideDown();
	},
	hideNewComplimentPanel: function() {
		$('.hide-me').slideUp();		
	},
	isPanelVisible: function() {
		return $('.hide-me').is(':visible');
	},
	stickyNewCompliment: function() {
		var stickMe = $('#scroll-sticky');
		var complimentContainer = $('#new-compliment-container');
		stickMe.waypoint({
			handler: function(event, direction) {
				complimentContainer.toggleClass('sticky', direction=='down');
			}
		});
	},
	validateSenderNotReceiver: function() {
		var element = $('input#compliment_receiver');
		var receiverUserId = $('input#compliment_receiver_id').val();
		console.log("Current User Id: " + ComplimentUI.userId + " Receiver User Id: " + receiverUserId);
		var errorMsg = "";
		if(ComplimentUI.userId == receiverUserId) {
			errorMsg = "I think you are talking to yourself again";
		}
		if(element.val() == null || element.val().length == 0) {
			errorMsg = "can't be blank";
		}
		var elementContainer = element.parents('#field');
		var existingError = elementContainer.find('#validation-error');
		if(existingError && existingError.length > 0) {
			existingError.html(errorMsg);
		} else {
			elementContainer.append('<div id="validation-error">' + errorMsg + '</div>');
		}
		if($('#validation-error').not(':visible')) {
			$('#validation-error').show();
		}
	}
}