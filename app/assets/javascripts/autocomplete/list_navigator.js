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
				ListNavigator.highlightElement(list);
			} else if(e.keyCode == 40) { // down arrow
				ListNavigator.index += 1;
				if(ListNavigator.index >= list.length) {
					ListNavigator.index = list.length - 1;
				}
				ListNavigator.highlightElement(list);
			} else if(e.keyCode == 13) { // enter key
				var listElement = list[ListNavigator.index];
				ListNavigator.handleSelect(listElement);
				return false;
			}
		});
		$('li.register-me').off('click');
		$('li.register-me').click(function() {
			listElement = this;
			ListNavigator.handleSelect(listElement);
		})
		$(list).on({
			hover: function() {
				ListNavigator.unhighlightList(this);
			}
		});
	},
	handleSelect: function(listElement) {
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
			ComplimentUI.validateSenderNotReceiver();
		} else {
			ComplimentUI.validateSenderNotReceiver();
		}
	},
	setInputAndClose: function(listElement) {
		var inputValue = $(listElement).find('.value-for-input-field');
		var inputId = $(listElement).find('.id-for-input-field');
		var receiverIsACompany = $(listElement).find('.is_a_company');
		$(ListNavigator.inputTextField).val($(inputValue).text());
		$(ListNavigator.inputIdField).val($(inputId).text());
		$(ListNavigator.receiverIsACompanyField).val($(receiverIsACompany).text());
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