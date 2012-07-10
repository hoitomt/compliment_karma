var ComplimentUI = {
	init: function() {
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
	}
}