var NewComplimentValidation = {
	errors: [],
	init: function(){

	},
	validateNewComplimentForm: function() {
		var allErrors = [];
		this.validateComplimentReceiver();
		allErrors = allErrors.concat(this.errors);
		this.validateComplimentSkill();
		allErrors = allErrors.concat(this.errors);
		this.validateComplimentComment();
		allErrors = allErrors.concat(this.errors);
		this.validateComplimentType();
		allErrors = allErrors.concat(this.errors);
		return allErrors.length == 0;
	},
	validateComplimentReceiver: function() {
		var element = $('input#compliment_receiver_display');
		this.errors = [];
		this.clearErrorMessage(element);
		// Sender is not the same as the receiver
		this.validateSenderNotReceiver();
		// Receiver email is valid
		this.validateEmail();
		// Field is blank
		this.validatePresence(element);
		$(this.errors).each(function() {
			NewComplimentValidation.showErrorMessage(this.element, this.errorMsg);
		});
	},
	validateComplimentSkill: function() {
		var element = $('input#compliment_skill_id');
		this.errors = [];
		this.clearErrorMessage(element);
		// Field is blank
		this.validatePresence(element);
		$(this.errors).each(function() {
			NewComplimentValidation.showErrorMessage(this.element, this.errorMsg);
		});
	},
	validateComplimentComment: function() {
		var element = $('#compliment_comment');
		this.errors = [];
		this.clearErrorMessage(element);
		// Field is blank
		this.validatePresence(element);
		this.validateCommentLength(element);
		$(this.errors).each(function() {
			NewComplimentValidation.showErrorMessage(this.element, this.errorMsg);
		});
	},
	validateComplimentType: function() {
		var element = $('#compliment_compliment_type_id');
		this.errors = [];
		this.clearErrorMessage(element);
		// Field is blank
		this.validatePresence(element);
		$(this.errors).each(function() {
			NewComplimentValidation.showErrorMessage(this.element, this.errorMsg);
		});
	},
	validateSenderNotReceiver: function() {
		var receiverError = false;
		var element = $('input#compliment_receiver_display');
		var receiverUserId = $('input#compliment_receiver_id').val();
		var errorMsg = "";
		if(ComplimentUI.userId == receiverUserId) {
			this.errors.push({element: element, 
									 errorMsg: "I think you are talking to yourself again"});
			receiverError = true;
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
		}
		return emailError;
	},
	validatePresence: function(element) {
		var receiverError = false;
		if(element.val() == null || element.val().length == 0) {
			this.errors.push({element: element, 
									 errorMsg: "can't be blank"});
			receiverError = true;
		}
		return receiverError;
	},
	validateCommentLength: function(element) {
		var commentError = false;
		var content = element.val();
		if(content && content.length > 140) {
			this.errors.push({element: element,
												errorMsg: "is too long - 140 character limit"});
			commentError = true;
		}
		return commentError;
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
		// Now that it has been set, go get it again
		var errorContainer = elementContainer.find('#validation-error');
		if($(errorContainer).not(':visible')) {
			$(errorContainer).show();
		}
	},
	clearErrorMessage: function(element) {
		var elementContainer = element.parents('#field');
		var errorContainer = elementContainer.find('#validation-error');
		errorContainer.html('');
		$(errorContainer).hide();
	}
}