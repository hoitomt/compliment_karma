var UserMenu = {
	init: function() {
		this.setCurrentMenuItem();
	},
	setCurrentMenuItem: function() {
		var currentAction = $('#current_action').val();
		var activeMenuItem = UserMenu.mapper(currentAction);
		console.log(activeMenuItem);
		$('#' + activeMenuItem).addClass('active');
	},
	clearMenuItems: function() {
		$('#user-menu').each('li', function() {
			this.removeClass('active');
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
			default: break;
		}
	}
}
