var ListNavigator = {
	index: 0,
	inputField: null,
	container: null,
	init: function(list, inputField, autoCompleteWindow) {
		this.index = 0;
		this.inputField = inputField;
		this.container = autoCompleteWindow;
		console.log(list[this.index]);
		this.highlightElement(list);
		this.addListHandlers(list);
	},
	addListHandlers: function(list) {
		$(document).off('keydown');
		$(document).keydown(function(e) {
			if(e.keyCode == 38) { // up arrow
				console.log("Going Up");
				ListNavigator.index -= 1;
				if(ListNavigator.index < 0) {
					ListNavigator.index = 0;
				}
				console.log(ListNavigator.index);
				ListNavigator.highlightElement(list);
			} else if(e.keyCode == 40) { // down arrow
				console.log("Going Down");
				ListNavigator.index += 1;
				if(ListNavigator.index >= list.length) {
					ListNavigator.index = list.length - 1;
				}
				console.log("Down: " + list.length + '|' + ListNavigator.index);
				ListNavigator.highlightElement(list);
			} else if(e.keyCode == 13) { // enter key
				var userId = list[ListNavigator.index].id;
				var userName = $(list[ListNavigator.index]).find('.user-name');
				console.log($(userName).html());
				if(inputField != null) {
					$(inputField).val($(userName).html());
					$(ListNavigator.container).hide();
				}
			}
		});
		$(list).on({
			hover: function() {
				ListNavigator.unhighlightList(this);
			}
		});
	},
	highlightElement: function(list) {
		listElement = list[this.index];
		ListNavigator.unhighlightList(list);
		$(listElement).addClass('active');
	},
	unhighlightElement: function(list) {
		$(listElement).removeClass('active');
	},
	unhighlightList: function(list) {
		$(list).each(function() {
			$(this).removeClass('active');
		});
	}
}