var ComplimentUI = {
	userId: 0,
	init: function(userId) {
		this.userId = userId
		this.setNewComplimentHandlers();
		this.stickyNewCompliment();
		this.setAjaxCallbacks();
	},
	flashBlue: function() {
		$('#new-compliment-container').effect("highlight", {color: "#006791"}, 2500);
	},
	setNewComplimentHandlers: function() {
		$('input#compliment_receiver_display').off('click, change, focus');
		$('input#compliment_receiver_display').click(function() {
			ComplimentUI.showNewComplimentPanel();
			// event.stopPropagation();
		});		
		$('input#compliment_receiver_display').focus(function() {
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
			ComplimentUI.updateReceiverType();
			ComplimentUI.updateComplimentType();
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
	removeStickyCompliment: function() {
		var stickMe = $('#scroll-sticky');
		stickMe.unbind('waypoint');
		$('#new-compliment-container').removeClass('sticky');
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
		if( !ComplimentUI.isValidEmail(element.val()) && 
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
	isValidEmail: function(email) {
		if(email == null || email.length == 0) {
			return false;
		}
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
	},
	updateReceiverType: function() {
		if( ComplimentUI.isValidEmail($('input#compliment_receiver_display').val()) ) {
			$('#receiver_is_a_company').val('false');
		}
	},
	updateComplimentType: function() {
		var receiverIsACompany = $('#receiver_is_a_company').val();
		var senderIsACompany = $('#sender_is_a_company').val();
		// console.log("update drop down| rcv: " + receiverIsACompany + ' snd: ' + senderIsACompany);
		$.ajax({
			url: '/compliments/set_compliment_types.js',
			type: 'GET',
			data: {sender_is_a_company: senderIsACompany,	
						 receiver_is_a_company: receiverIsACompany }
		});
	},
	setAjaxCallbacks: function() {
		$('#compliment-form').unbind('ajax:beforeSend');
		$('#compliment-form').bind('ajax:beforeSend', function(evt, data, status, xhr){
			$('#sending-compliment-spinner').show();
		});
		$('#compliment-form').bind('ajax:success', function(evt, data, status, xhr){
			$('#sending-compliment-spinner').hide();
			alert("Your compliment was successfully sent");
			ComplimentUI.resetNewComplimentValues();
		});
	},
	resetNewComplimentValues: function() {
		$('#compliment_receiver_display').val('');
		$('#compliment_skill_id').val('');
		$('#compliment_comment').val('');
		$('#compliment_compliment_type_id').val('select compliment type');

		$('#receiver_is_a_company').val('false');
		$('#skill_id_result').val('');
		$('#compliment_receiver_id').val('');
		ComplimentUI.hideNewComplimentPanel();
	}
}