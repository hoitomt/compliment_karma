var ListNavigator = {
	index: 0,
	inputTextField: null,
	inputIdField: 0,
	container: null,
	init: function(list, inputTextField, inputIdField, container) {
		this.index = 0;
		this.inputTextField = inputTextField;
		this.inputIdField = inputIdField;
		this.container = container;
		this.highlightElement(list);
		this.addListHandlers(list);
	},
	addListHandlers: function(list) {
		$(document).off('keydown');
		$(document).keydown(function(e) {
			if(e.keyCode == 38) { // up arrow
				ListNavigator.index -= 1;
				if(ListNavigator.index < 0) {
					ListNavigator.index = 0;
				}
				// console.log("Up: " + ListNavigator.index);
				ListNavigator.highlightElement(list);
			} else if(e.keyCode == 40) { // down arrow
				ListNavigator.index += 1;
				if(ListNavigator.index >= list.length) {
					ListNavigator.index = list.length - 1;
				}
				// console.log("Down: " + ListNavigator.index);
				ListNavigator.highlightElement(list);
			} else if(e.keyCode == 13) { // enter key
				var listElement = list[ListNavigator.index];
				ListNavigator.setInputAndClose(listElement);
				return false;
			}
		});
		$('li.register-me').off('click');
		$('li.register-me').click(function() {
			ListNavigator.setInputAndClose($(this)[0])
		})
		$(list).on({
			hover: function() {
				ListNavigator.unhighlightList(this);
			}
		});
	},
	setInputAndClose: function(listElement) {
		console.log(listElement);
		var inputValue = $(listElement).find('.value-for-input-field');
		var inputId = $(listElement).find('.id-for-input-field');
		$(ListNavigator.inputTextField).val($(inputValue).html());
		$(ListNavigator.inputIdField).val($(inputId).html());
		$(ListNavigator.container).hide();
	},
	highlightElement: function(list) {
		listElement = list[this.index];
		ListNavigator.unhighlightList(list);
		$(listElement).addClass('xactive');
	},
	unhighlightElement: function(list) {
		$(listElement).removeClass('xactive');
	},
	unhighlightList: function(list) {
		$(list).each(function() {
			$(this).removeClass('xactive');
		});
	}
}