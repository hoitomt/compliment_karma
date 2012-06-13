var UserProfile = {
	init: function(userId, perPage, userEmail) {
		$('#processing').hide();
		$('#end-of-list').hide();
		$('#select-processing').hide();
		$('#infinite-scroll-processing').hide();
		
		this.setDocState(userId, perPage);
		// this.infiniteScrolling();
		this.feed_items_filters(userId);
		this.formValidation();
		this.reinitialize();
		this.setValidateSenderNotReceiver(userEmail);
		this.validateSenderNotReceiver(userEmail);
	},
	reinitialize: function() {
		this.stripeTable();
		this.hideSubMenu();
		this.hoverKarmaLiveItems();
		this.hideSocialItemHelpers();
		this.socialClickHandlers();
		this.showCommentButtonOnClick();
	},
	docState: {
		currentCount: 0,
		page: 1,
		perPage: 0,
		totalCount: 0,
		userId: 0
	},
	setDocState: function(userId, perPage) {
		this.docState.totalCount = parseInt($('#feed_items_count').val());
		this.docState.perPage = parseInt(perPage);
		this.docState.userId = userId;
	},
	infiniteScrolling: function() {
		docState = this.docState
		var userId = docState.userId;
		var perPage = docState.perPage;
		var retrieveFlag = false;
		$(document).scroll(function() {
			var feed_item_type_id = $('#feed_item_type').val();
			var relation_type_id = $('#relation_type').val();
			var distanceFromBottom = $(document).height() - ($(window).scrollTop() + $(window).height());
		  docState.currentCount = docState.page * perPage;
			if(docState.currentCount < docState.totalCount) {
				if(distanceFromBottom < 100 && !retrieveFlag) {
					retrieveFlag = true;
					docState.page++;
					// Get more records
					$.ajax({
						url: '/users/' + userId + '/get_more_karma_live_records',
						type: 'POST',
						data: { page: docState.page, feed_item_type: feed_item_type_id, relation_type: relation_type_id},
						beforeSend: function() {
							// $.jGrowl("Let's get more records!");
							$('#infinite-scroll-processing').show();
						},
						complete: function() {
								retrieveFlag = false;
								$('#infinite-scroll-processing').hide();
						}
					})
				}
			} else if(distanceFromBottom > 50) {
				// jGrowl("Thats all of them");
			}
		});
	},
	feed_items_filters: function(userId) {
		$('#feed_item_type').change(function() {
			var feed_item_type_id = $('#feed_item_type').val();
			var relation_type_id = $('#relation_type').val();
			processSelect(userId, feed_item_type_id, relation_type_id)
		});
		$('#relation_type').change(function() {
			var feed_item_type_id = $('#feed_item_type').val();
			var relation_type_id = $('#relation_type').val();
			processSelect(userId, feed_item_type_id, relation_type_id)
		});
	},
	formValidation: function() {
		this.hideAllHelpers();

		$('#compliment_receiver_email').focus(function() {
			SkillAutoComplete.hideResults();
			$('#compliment_receiver_email_helper').show(200);
		});
		$('#compliment_receiver_email').blur(function() {
			$('#compliment_receiver_email_helper').hide(200);
		});

		// $('#compliment_skill').focus(function() {
		// 	$('#compliment_skill_helper').show(200);
		// });
		// $('#compliment_skill').blur(function() {
		// 	$('#compliment_skill_helper').hide(200);
		// });

		$('#compliment_comment').focus(function() {
			SkillAutoComplete.hideResults();
			$('#compliment_comment_helper').show(200);
		});
		$('#compliment_comment').blur(function() {
			$('#compliment_comment_helper').hide(200);
		});

		$('#compliment_relation').focus(function() {
			SkillAutoComplete.hideResults();
			$('#compliment_relation_helper').show(200);
		});
		$('#compliment_relation').blur(function() {
			$('#compliment_relation_helper').hide(200);
		});	
	},
	hideAllHelpers: function() {
		$('#compliment_receiver_email_helper').hide();
		$('#compliment_skill_helper').hide();
		$('#compliment_comment_helper').hide();
		$('#compliment_relation_helper').hide();
	},
	hoverKarmaLiveItems: function() {
		// $("ul#feed-items").off('click mouseover mouseout', 'li.item');
		$("ul#feed-items").off('click mouseover mouseout', '.item-click-me');
		$("ul#feed-items").off('click mouseover mouseout', '.social-hide-me');
		$("ul#feed-items").on({
			mouseover: function() {
				$(this).show();
			}
		}, '.social-hide-me');
		$("ul#feed-items").on({
			mouseover: function() {
				UserProfile.hideSocialItemHelpers();
				$(this).addClass('hovered')
				UserProfile.showSocialItemHelpers(this);
			},
			mouseout: function() {
				UserProfile.hideSocialItemHelpers();
				$(this).removeClass('hovered');	
			}
		},'.item');
	},
	showSocialItemHelpers: function(item) {
		$(item).find('.social-hide-me').show();
	},
	hideSocialItemHelpers: function() {
		$('.social-hide-me').hide();
	},
	hideSubMenu: function() {
		$('.sub-menu').hide();
	},
	socialClickHandlers: function() {
		$("ul#social-links-list").off('mouseout', '.feed-item-social');
		$("ul#social-links-list").on({
			mouseout: function() {
				UserProfile.hideSubMenu();
			}
		});
		$('.social-compliment').off('mouseover mouseout');
		$('.social-compliment').on({
			mouseover: function(event) {
				UserProfile.hideSubMenu();
				$(this).find('.sub-menu').show();
			},
		});
		$('.social-follow').off('mouseover mouseout');
		$('.social-follow').on({
			mouseover: function(event) {
				UserProfile.hideSubMenu();
				$(this).find('.sub-menu').show();
			},
		});
		$('.social-share').off('mouseover');
		$('.social-share').on({
			mouseover: function(event) {
				UserProfile.hideSubMenu();
				$(this).find('.sub-menu').show();
			}
		});
		$('.social-comment').off('mouseover');
		$('.social-comment').on('mouseover', function() {
			UserProfile.hideSubMenu();
		});
	},
	getData: function(p) {
		var data = {
			'sender_user_id': 0,
			'receiver_user_id': 0,
			'recognition_type_id': p.find('#recognition-type-id')[0].value,
			'recognition_id': p.find('#recognition-id')[0].value,
			'count': p.find('#count-id')[0].value,
			'user_id': p.find('#user-id')[0].value,
			'current_user_id': p.find('#current-user-id')[0].value,
			'recipient_id': 0
		};
		return data;
	},
	hideSlideSocialItemHelpers: function() {
		$('.social-hide-me').slideUp();
	},
	resetPage: function() {
		$('#feed-items').scrollTop(0);
		docState.currentCount = 0;
		docState.page = 1;
		docState.totalCount = parseInt($('#feed_items_count').val());
	},
	setValidateSenderNotReceiver: function(userEmail) {
		$('#compliment_receiver_email').blur(function() {
			UserProfile.validateSenderNotReceiver(userEmail);
		});
	},
  validateSenderNotReceiver: function(userEmail) {
	  element = $('#compliment_receiver_email');
		if(element.val() == userEmail) {
			var errorMsg = "I think you are talking to yourself again";
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
	},
	showCommentButtonOnClick: function() {
		$('#popup-compliment-comment').off('focus');
		$('#popup-compliment-comment').on({
			focus: function() {
				console.log("Slide");
				$('.comment-text-new-submit').slideDown();
			}
		});
	},
	stripeTable: function() {
		$('.stripe-me tr:odd').addClass('alt');
	}
}



