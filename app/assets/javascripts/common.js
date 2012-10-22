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
		if(flashContent.length > 0) {
			$('#explanation').slideDown();
			$('#explanation').html(flashContent);
			setTimeout(function() {
				$('#explanation').slideUp();
			}, 17500);
			this.setCloseHandler();
		}
	},
	setCloseHandler: function() {
		$('#close-x').click(function() {
			$('#explanation').slideUp();
		  $('#flash').slideUp();
		});
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
	},
	testIe: function() {
		alert('working');
	},
	jsonTest: function() {

// $().ready(function(){ 
//     var url = 'http://www.panoramio.com/wapi/data/get_photos?callback=?';
//     $.get(url, function(data) {
//         // can use 'data' in here...
//     });
// });

		var url = 'http://www.complimentkarma.com/compliments/count?callback=?'
		$.getJSON(url, function(data){
			// $.each(data, function(key, val) {
		 //  });
		})
		// var url = "http://www.complimentkarma.com/compliments/count.json";
		// var client = new XMLHttpRequest();
		// client.open("GET", url, false);
		// client.setRequestHeader("Content-Type", "application/json");
		// client.send();
	},
	closeNarrowFlash: function($container) {
		var existingFlash = $container.find('#flash-narrow');
		$(existingFlash).slideUp();
		// $(existingFlash).each(function() {
		// 	$container.remove(this);
		// });
	},
	setFacebookHandler: function() {
		d = document;
		s = 'script';
		id = 'facebook-jssdk';
	  var js, fjs = d.getElementsByTagName(s)[0];
	  if (d.getElementById(id)) return;
	  js = d.createElement(s); js.id = id;
	  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
	  fjs.parentNode.insertBefore(js, fjs);
	},
	showSpinner: function() {
    $('a.show-spinner').on('ajax:beforeSend', function(event, xhr, settings) {
      $('body').css('cursor', 'progress');
    });
    $('a.show-spinner').on('ajax:complete', function(event, xhr, settings) {
      $('body').css('cursor', 'auto');
    });
	}
}

