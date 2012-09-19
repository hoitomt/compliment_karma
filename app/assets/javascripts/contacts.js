function Contact(el) {
	this.$el = $(el);
	var showPopupEl = this.$el.find('.show-contact-type');
	var deleteLinkEl = this.$el.find('.delete-link');
	var popup = $(el).find('.popup');
	this.$popup = $(popup);
	this.$showPopupEl = $(showPopupEl);
	this.$deleteLinkEl = $(deleteLinkEl);
	this.bindEvents();
}

Contact.prototype.bindEvents = function() {
	var contactObj = this;
	this.$el.hover(
		function(e) {
			contactObj.$deleteLinkEl.show();
			$(this).addClass('hover');
		},
		function(e) {
			contactObj.$deleteLinkEl.hide();
			$(this).removeClass('hover');
		}
	);
	this.$showPopupEl.hover(
		function(e) {
			contactObj.showPopup(this);
		},
		function(e) {
			contactObj.hidePopup(this);
		}
	)
	this.$popup.hover(
		function(e) {
			contactObj.showPopup(this);
		},
		function(e) {
			contactObj.hidePopup(this);
		}
	)
}

Contact.prototype.showPopup = function() {
	var offset = this.$el.offset();
	var offsetOptions = {
		top: offset.top + this.$el.height() + $(window).scrollTop(),
		left: offset.left
	}
	this.$popup.offset(offsetOptions);
	this.$popup.find('li').hover(
		function(e){
			$(this).addClass('list-hover');
		},
		function(e){
			$(this).removeClass('list-hover');
		}
	)
	this.$popup.show();
}

Contact.prototype.hidePopup = function(el) {
	this.$popup.offset({top: 0, left: 0});
	this.$popup.hide();
	// var popup = $(el).find('.popup');
	// $(popup).offset({top: 0, left: 0});
	// $(popup).hide();
}