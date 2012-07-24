var CommonScripts = {
	init: function() {
		this.toggleScrolling();
		this.inputStyle();
	},
	toggleScrolling: function() {
		// Remove infinite scrolling for pages that don't require it
		var karmaLive = $('#karma-live-updates');
		if(karmaLive == null || karmaLive == undefined || karmaLive.size() < 1) {
			$(document).off('scroll');
			return;
		}
	},
	showFlash: function(flashContent) {
		// console.log(flashContent);
		// console.log("Flash Null: " + flashContent.length > 0);
		if(flashContent.length > 0) {
			$('#explanation').slideDown();
			$('#explanation').html(flashContent);
			setTimeout(function() {
				$('#explanation').slideUp();
			}, 7500);
		}

	},
	stickyFlashContainer: function() {
		var stickMe = $('#flash-container');
		var flashContainer = $('#explanation');
		stickMe.waypoint({
			handler: function(event, direction) {
				flashContainer.toggleClass('sticky', direction=='down');
			}
		});
	},
	inputStyle: function() {
		// Deal with the placeholder text
		var inputs = $.merge($('input'), $('textarea'));
		$.each(inputs, function() {
			if($(this).val() && $(this).val().length > 0) {
				$(this).css('text-align', 'left');
				$(this).css('color', '#000000');
			}
			$(this).data('holder', $(this).attr('placeholder'));
			$(this).focus(function() {
				// $(this).css('text-align', 'center');
				$(this).attr('placeholder', '');
			});
			$(this).keypress(function() {
				// $(this).css('text-align', 'left');
				$(this).css('color', '#000000');
			});
			$(this).blur(function() {
				if(!this.value || this.value.length == 0) {
					$(this).css('text-align', 'center');
					// $(this).css('color', '#999999');
					$(this).attr('placeholder', $(this).data('holder'));
				}
			});
		});
	}

}

