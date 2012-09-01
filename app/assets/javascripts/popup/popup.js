function Popup(el) {
	this.$el = $(el);
	this.bindEvents();
};

Popup.prototype.bindEvents = function() {
	this.$el.on({
		mouseover: function() {
			console.log("Cool");
		},
		mouseout: function() {
			console.log("Not Cool")
		}
	});
};
