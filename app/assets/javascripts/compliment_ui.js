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
		$('input#compliment_receiver_display').off('click, change');
		$('input#compliment_receiver_display').click(function() {
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
		$('input#compliment_receiver_display').off('change blur');
		$('input#compliment_receiver_display').change(function(event) {
			// console.log("Input Change");
			ComplimentUI.validateComplimentReceiver();
			setTimeout( function() {
				$('#compliment-receiver-results-container').hide();
			}, 200);
		});
		$('input#compliment_receiver_display').blur(function(event) {
			// console.log("Input Blur");
			ComplimentUI.validateComplimentReceiver();
			setTimeout( function() {
				$('#compliment-receiver-results-container').hide();
			}, 200);
		});
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
	validateComplimentReceiver: function() {
		ComplimentUI.validateSenderNotReceiver();
	},
	validateSenderNotReceiver: function() {
		// console.log("Validate");
		var element = $('input#compliment_receiver_display');
		var receiverUserId = $('input#compliment_receiver_id').val();
		// console.log("Current User Id: " + ComplimentUI.userId + " Receiver User Id: " + receiverUserId);
		var errorMsg = "";
		if(ComplimentUI.userId == receiverUserId) {
			errorMsg = "I think you are talking to yourself again";
		}
		var emailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i;
		if( !ComplimentUI.validateEmail(element.val()) && 
				(receiverUserId == null || receiverUserId.length == 0) ) {
			errorMsg = "invalid email address";
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
	},
	validateEmail: function(email) {
		if(email == null || email.length == 0) {
			return false;
		}
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
	}
}