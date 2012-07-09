var UserMenu = {
	init: function() {
		var currentAction = $('#current_action').val();
		this.setCurrentMenuItem(currentAction);
	},
	setCurrentMenuItem: function(currentAction) {
		var activeMenuItem = UserMenu.mapper(currentAction);
		UserMenu.clearMenuItems();
		$('#' + activeMenuItem).addClass('active');
	},
	clearMenuItems: function() {
		$('#user-menu li').each(function() {
			$(this).removeClass('active');
		});
	},
	mapper: function(currentAction) {
		switch (currentAction) {
			case 'show': return 'menu-karma-live';
			case 'professional_profile': return 'menu-professional-profile';
			case 'social_profile':  return 'menu-social-profile';
			case 'received_compliments':  return 'menu-received-compliments';
			case 'sent_compliments': return 'menu-sent-compliments';
			case 'achievements':  return 'menu-achievements';
			case 'contacts': return 'menu-contacts';
			case 'settings': return 'menu-settings';
			case 'employees': return 'menu-employees';
			default: break;
		}
	}
}
