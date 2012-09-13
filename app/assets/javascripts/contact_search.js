function ContactSearch(el) {
	this.$el = $(el);
	var parent = this.$el.parents('.contact-search-result');
	this.$elListParent = $(parent);
	var c = this.$elListParent.find('#new-contact-type-form');
	this.$elForm = $(c);
	this.bindEvents();
}

ContactSearch.prototype.bindEvents = function() {
	var obj = this;
	this.$el.click(function(event) {
		obj.$elListParent.off('hover');
		obj.toggleFormDisplay();
	});	
	this.$el.hover(
		function(event) {
			obj.$elListParent.off('hover');
			obj.toggleFormDisplay();
		},
		function(event) {
			obj.$elListParent.off('hover');
			obj.toggleFormDisplay();
		}
	);
}

ContactSearch.prototype.toggleFormDisplay = function() {
	if(this.$elForm.is(':visible')) {
		this.$elForm.hide();
	} else {
		this.$elForm.slideDown();
		this.setPopupPosition();
	}
}

ContactSearch.prototype.setPopupPosition = function() {
	var offsetOptions = {
		top: this.$el.offset().top + this.$el.height(),
		left: this.$el.offset().left
	}
	this.$popup.offset(offsetOptions);
}

ContactSearch.prototype.resetPopupPosition = function() {
	this.$popup.offset({top: 0, left: 0});
}