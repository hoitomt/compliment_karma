var NewComplimentValidation = {
	errors: [],
	init: function(){

	},
	validateNewComplimentForm: function() {
		this.validateComplimentReceiver();

	},
	validateComplimentReceiver: function() {
		this.errors = [];
		var element = $('input#compliment_receiver_display');
		this.clearErrorMessage(element);
		// Sender is not the same as the receiver
		this.validateSenderNotReceiver();
		// Receiver email is valid
		this.validateEmail();
		// Field is blank
		this.validatePresence();
		$(this.errors).each(function() {
			NewComplimentValidation.showErrorMessage(this.element, this.errorMsg);
		});
	},
	validateSenderNotReceiver: function() {
		var receiverError = false;
		var element = $('input#compliment_receiver_display');
		var receiverUserId = $('input#compliment_receiver_id').val();
		// console.log("Current User Id: " + ComplimentUI.userId + " Receiver User Id: " + receiverUserId);
		var errorMsg = "";
		if(ComplimentUI.userId == receiverUserId) {
			this.errors.push({element: element, 
									 errorMsg: "I think you are talking to yourself again"});
			receiverError = true;
			console.log("Sender == receiver");
		}
		return receiverError;
	},
	validateEmail: function() {
		var emailError = false;
		var element = $('input#compliment_receiver_display');
		var receiverUserId = $('input#compliment_receiver_id').val();
		email = element.val()
		if(email == null || email.length == 0) {
			return;
		}
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

    if( !re.test(email) && 
				(receiverUserId == null || receiverUserId.length == 0) ) {
			this.errors.push({element: element, 
									 errorMsg: "invalid email address"});
			emailError = true;
			console.log("Invalid Email");
		}
		return emailError;
	},
	validatePresence: function() {
		var receiverError = false;
		var element = $('input#compliment_receiver_display');
		if(element.val() == null || element.val().length == 0) {
			this.errors.push({element: element, 
									 errorMsg: "can't be blank"});
			receiverError = true;
		}
		return receiverError;
	},
	// element should be in the form of $('input#field_name')
	showErrorMessage: function(element, errorMsg) {
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
	clearErrorMessage: function(element) {
		var elementContainer = element.parents('#field');
		var existingError = elementContainer.find('#validation-error');
		existingError.html('');
		$('#validation-error').hide();
	}
}