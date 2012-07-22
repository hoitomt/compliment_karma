var UserProfile = {
	init: function(userId, perPage, totalCount, userEmail) {
		$('#processing').hide();
		$('#end-of-list').hide();
		$('#select-processing').hide();
		$('#infinite-scroll-processing').hide();
		
		this.setDocState(userId, perPage, totalCount);
		this.feed_items_filters(userId);
		this.formValidation();
		this.reinitialize();
		this.setUnconfirmedUserPanelHeight();
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
	setDocState: function(userId, perPage, totalCount) {
		if(totalCount != null) {
			this.docState.totalCount = parseInt(totalCount);
		}
		this.docState.perPage = parseInt(perPage);
		this.docState.userId = userId;
	},
	infiniteScrolling: function() {
		docState = this.docState
		var userId = docState.userId;
		var perPage = docState.perPage;
		var retrieveFlag = false;
		$(document).off('scroll');
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
	removeInfiniteScroll: function() {
		$(document).unbind('scroll');
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

		$('#compliment_receiver_display').focus(function() {
			SkillAutoComplete.hideResults();
			$('#compliment_receiver_helper').show(200);
		});
		$('#compliment_receiver_display').blur(function() {
			$('#compliment_receiver_helper').hide(200);
		});

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
		$('#compliment_receiver_helper').hide();
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
		$('#compliment_receiver_display').blur(function() {
			UserProfile.validateSenderNotReceiver(userEmail);
		});
	},
	showCommentButtonOnClick: function() {
		$('#popup-compliment-comment').off('focus blur');
		$('#popup-compliment-comment').on({
			focus: function() {
				$('.comment-text-new-submit').slideDown();
			}
		});
		$('html').click(function(event) {
			var clickSrc = event.srcElement;
			var parent = $(clickSrc).parents('.comment-text-new');
			// console.log(parent);
			if(parent.length == 0) {
				UserProfile.hideCommentSubmitButton();
			}
		})
	},
	hideCommentSubmitButton: function() {
		$('.comment-text-new-submit').slideUp();
	},
	clearComment: function() {
		$('textarea#popup-compliment-comment').val('');
	},
	stripeTable: function() {
		$('.stripe-me tr:odd').addClass('alt');
	},
	followButtonHover: function() {
		$('.follow-button').off('mouseover mouseout');
		$('.follow-button').on({
			mouseover: function(event) {
				var followText = $(this).html();
				if(followText == "Following") {
					$(this).html('Unfollow');
				};
			},
			mouseout: function(event) {
				var followText = $(this).html();
				if(followText == "Unfollow") {
					$(this).html('Following');
				};
			}
		});
	},
	setUnconfirmedUserPanelHeight: function() {
		var unclickable = $('.unclickable');
		if(unclickable != null) {
			var height = $('#new-compliment-container').height();
			unclickable.height(height);
		}
 	}
}



