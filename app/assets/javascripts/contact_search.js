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
}

ContactSearch.prototype.toggleFormDisplay = function() {
	if(this.$elForm.is(':visible')) {
		this.$elForm.slideUp();
	} else {
		this.$elForm.slideDown();
	}
}