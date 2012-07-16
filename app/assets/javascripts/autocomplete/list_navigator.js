var ListNavigator = {
	index: 0,
	inputTextField: null,
	inputIdField: 0,
	receiverIsACompanyField: false,
	container: null,
	init: function(list, inputTextField, inputIdField, receiverIsACompanyField, container) {
		this.index = 0;
		this.inputTextField = inputTextField;
		this.inputIdField = inputIdField;
		this.receiverIsACompanyField = receiverIsACompanyField;
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
				// Make sure we only care about enter for the appropriate results
				var skillAutoCompleteContainer = $(listElement).parents('#skill-auto-complete');
				var complimentReceiverContainer = $(listElement).parents('#compliment-receiver-results');
				var siteSearchContainer = $(listElement).parents('#site-search-results');
				if(siteSearchContainer.length > 0) {
					ListNavigator.retrieveUserAndClose(listElement);
				} else if (skillAutoCompleteContainer.length > 0) {
					ListNavigator.setInputAndClose(listElement);
				} else if (complimentReceiverContainer.length > 0) {
					ListNavigator.setInputAndClose(listElement);
				}
				return false;
			}
		});
		$('li.register-me').off('click');
		$('li.register-me').click(function() {
			// console.log("clicky register");
			ListNavigator.setInputAndClose($(this)[0])
			ComplimentUI.validateSenderNotReceiver();
		})
		$(list).on({
			hover: function() {
				ListNavigator.unhighlightList(this);
			}
		});
	},
	setInputAndClose: function(listElement) {
		var inputValue = $(listElement).find('.value-for-input-field');
		var inputId = $(listElement).find('.id-for-input-field');
		var receiverIsACompany = $(listElement).find('.is_a_company');
		$(ListNavigator.inputTextField).val($(inputValue).html());
		$(ListNavigator.inputIdField).val($(inputId).html());
		$(ListNavigator.receiverIsACompanyField).val($(receiverIsACompany).html());
		$(ListNavigator.container).hide();
	},
	retrieveUserAndClose: function(listElement) {
		var inputId = $(listElement).find('.id-for-input-field');
		SiteSearch.retrieveUser($(inputId).html());
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