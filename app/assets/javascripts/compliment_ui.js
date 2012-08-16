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
		$('input#compliment_receiver_display').off('click, change, focus, blur');
		$('input#compliment_receiver_display').on({
			click: function() {
				ComplimentUI.showNewComplimentPanel();
			// event.stopPropagation();
			},
			focus: function() {
				ComplimentUI.showNewComplimentPanel();
				// event.stopPropagation();
			},
			change: function(event) {
				// setTimeout( function() {
				// 	$('#compliment-receiver-results-container').hide();
				// }, 200);
			},
			blur: function(event) {
				NewComplimentValidation.validateComplimentReceiver();
				ComplimentUI.updateReceiverType();
				ComplimentUI.updateComplimentType();
				setTimeout( function() {
					$('#compliment-receiver-results-container').hide();
				}, 200);
			}
		});
		$('input#compliment_skill_id').off('blur');
		$('input#compliment_skill_id').on({
			blur: function(event) {
				NewComplimentValidation.validateComplimentSkill();
			}
		});
		$('#compliment_comment').off('blur');
		$('#compliment_comment').on({
			blur: function(event) {
				NewComplimentValidation.validateComplimentComment();
			}
		});
		$('#compliment_compliment_type_id').off('blur');
		$('#compliment_compliment_type_id').on({
			blur: function(event) {
				NewComplimentValidation.validateComplimentType();
			}
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
			if(!isAnchor/* && !isInContainer*/) {
				ComplimentUI.hideNewComplimentPanel();
			}
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
		console.log("Add Sticky");
		var stickMe = $('#scroll-sticky');
		var complimentContainer = $('#new-compliment-container');
		stickMe.waypoint({
			handler: function(event, direction) {
				console.log("Sticky Fired");
				complimentContainer.toggleClass('sticky', direction=='down');
			}
		});
	},
	removeStickyCompliment: function() {
		console.log("Remove Sticky");
		var stickMe = $('#scroll-sticky');
		stickMe.off('waypoint');
		$('#new-compliment-container').removeClass('sticky');
	},
	updateReceiverType: function() {
		if( NewComplimentValidation.validateEmail() ) {
			$('#receiver_is_a_company').val('false');
		}
	},
	updateComplimentType: function() {
		// Update the compliment types drop down based on the receiver
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
		$('#compliment-form').off('ajax:beforeSend');
		$('#compliment-form').on('ajax:beforeSend', function(evt, data, status, xhr){
			var isValid = NewComplimentValidation.validateNewComplimentForm();
			if(!isValid) {
				return false;
			}
			$('#sending-compliment-spinner').show();
			// Shut off spinner if running for 10 seconds, something went wrong
			setTimeout($('#sending-compliment-spinner').hide, 10000);
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