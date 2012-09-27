function Privacy(el) {
	this.$el = $(el); //list element
	var cb = $(el).find('input[type=checkbox]');
	this.$cb = $(cb);
	this.groupName = $(el).find('#group-name').html();
	// console.log(this.groupName);
	this.fullList = $(el).closest('ul');
	// console.log(this.fullList);
	this.bindEvents();
	this.Contacts = 'Contacts';
	this.Public = 'Public';
}

Privacy.prototype.bindEvents = function() {
	var privacyObj = this;

	this.$el.off('click');
	this.$el.click(function(event) {
		var checkboxClicked = $(event.target).is(':input');
		if(checkboxClicked) {
			privacyObj.applyGroupRules();
		} else {
			var cb = $(this).find('input[type=checkbox]');
			if($(cb).is(':checked')) {
				$(cb).attr('checked', false);
			} else {
				$(cb).attr('checked', true);
			}
			privacyObj.applyGroupRules();
		}
	});
}

Privacy.prototype.applyGroupRules = function() {
	if(this.groupName == this.Public && this.isPublicChecked()) {
		this.checkAll();
	} 
	if(this.groupName != this.Public && this.isPublicChecked()){
		this.uncheckPublic();
	}
	if(this.groupName == this.Contacts && this.isContactsChecked()) {
		console.log("Check Contacts Children");
		this.checkContactsChildren();
	}
	if(this.groupName != this.Contacts && 
		 this.groupName != this.Public && 
		 this.isContactsChecked()) {
		this.uncheckContacts();
	}
}

Privacy.prototype.checkAll = function() {
	$(this.fullList).find('li').each(function() {
		var cbx = $(this).find('input[type=checkbox]');
		$(cbx).attr('checked', true);
	});
}

Privacy.prototype.checkContactsChildren = function() {
	var privacyObj = this;
	$(this.fullList).find('li').each(function() {
		var groupNameX = $(this).find('#group-name').html();
		if(groupNameX != privacyObj.Public) {
			console.log(groupNameX);
			var cbx = $(this).find('input[type=checkbox]');
			$(cbx).attr('checked', true);
		}
	});
}

Privacy.prototype.isContactsChecked = function() {
	return this.isFieldChecked(this.Contacts);
}

Privacy.prototype.isPublicChecked = function() {
	return this.isFieldChecked(this.Public);
}

Privacy.prototype.isFieldChecked = function(fieldName) {
	var fieldChecked = false;
	$(this.fullList).find('li').each(function() {
		var groupNameX = $(this).find('#group-name').html();
		if(groupNameX == fieldName) {
			var fieldCb = $(this).find('input[type=checkbox]');
			if($(fieldCb).is(':checked')) {
				fieldChecked = true;
			}
		}
	});
	return fieldChecked;
}

Privacy.prototype.uncheckPublic = function() {
	this.uncheckField(this.Public);
}

Privacy.prototype.uncheckContacts = function() {
	this.uncheckField(this.Contacts);
}

Privacy.prototype.uncheckField = function(fieldName) {
	$(this.fullList).find('li').each(function() {
		var groupNameX = $(this).find('#group-name').html();
		if(groupNameX == fieldName) {
			var fieldCb = $(this).find('input[type=checkbox]');
			$(fieldCb).attr('checked', false);
		}
	});
}