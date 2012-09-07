function Contact(el) {
	this.$el = $(el);
	this.bindEvents();
}

Contact.prototype.bindEvents = function() {
	var contactObj = this;
	this.$el.hover(
		function(e) {
			$(this).addClass('hover');
			contactObj.showPopup(this);
		},
		function(e) {
			$(this).removeClass('hover');
			contactObj.hidePopup(this);
		}
	);
}

Contact.prototype.showPopup = function(el) {
	var popup = $(el).find('.popup');
	var offsetOptions = {
		top: $(el).offset().top + $(el).height(),
		left: $(el).offset().left
	}
	$(popup).offset(offsetOptions);
	$(popup).find('li').hover(
		function(e){
			$(this).addClass('list-hover');
		},
		function(e){
			$(this).removeClass('list-hover');
		}
	)
	$(popup).show();
}

Contact.prototype.hidePopup = function(el) {
	var popup = $(el).find('.popup');
	$(popup).offset({top: 0, left: 0});
	$(popup).hide();
}