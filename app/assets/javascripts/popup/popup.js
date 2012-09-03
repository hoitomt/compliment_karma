function Popup(el, popup) {
	this.$el = $(el);
	this.$popup = $(popup);
	this.hidePopup();
	// this.bindEvents();
};

Popup.prototype.showPopup = function() {
	var offsetOptions = {
		top: this.$el.offset().top + 20,
		left: this.$el.offset().left
	}
	this.$popup.offset(offsetOptions);
	this.$popup.show();
}

Popup.prototype.hidePopup = function(popup) {
	this.$popup.offset({top: 0, left: 0});
	this.$popup.hide();
}

Popup.prototype.bindEvents = function() {
	var popObj = this;
	this.$el.on({
		mouseover: function(e) {
			console.log('hover');
			popObj.showPopup();
		},
		mouseout: function(e) {
			popObj.hidePopup();
		}
	});
	this.$popup.on({
		mouseover: function(e) {
			popObj.showPopup();
		},
		mouseout: function(e) {
			popObj.hidePopup();
		}
	});
};
