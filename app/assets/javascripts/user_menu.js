var UserMenu = {
	init: function() {
		var currentAction = $('#current_action').val();
		this.setCurrentMenuItem(currentAction);
		// this.setMenuChangeHandler();
	},
	setMenuChangeHandler: function() {
		var menuList = $('#user-menu-list li')

		// UserMenu.setCurrentMenuItem(currentAction);
		ComplimentUI.removeStickyCompliment();
		UserProfile.removeInfiniteScroll();
		scroll(0,0);
		FooterResize.init();
	},
	setCurrentMenuItem: function(currentAction) {
		var activeMenuItem = UserMenu.mapper(currentAction);
		UserMenu.clearMenuItems();
		$('#' + activeMenuItem).addClass('active');
		// FooterResize.init();
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
	},
	switchView: function(currentAction, view) {
		switch(currentAction) {
			case "professional_profile":
				$('#content-container').html('<%= j(render "users/menu/professional_profile") %>');
				UserProfile.stripeTable();
				break;
			case "social_profile":
				$('#content-container').html('<%= j(render "users/menu/social_profile") %>');
				UserProfile.stripeTable();
				break;
			case "received_compliments":
				$('#content-container').html('<%= j(render "users/menu/received_compliments") %>');
				break;
			case "sent_compliments":
				$('#content-container').html('<%= j(render "users/menu/sent_compliments") %>');
				break;
			case "achievements":
				$('#content-container').html('<%= j(render "users/menu/achievements") %>');
				break;
			case "contacts":
				$('#content-container').html('<%= j(render "users/menu/contacts") %>');
				break;
			case "settings":
				$('#content-container').html('<%= j(render "users/menu/settings") %>');
				break;
			case "employees":
				$('#content-container').html('<%= j(render "users/menu/employees") %>');
				break;
			case "show":
				$('#content-container').html('<%= j(render "users/menu/karma_live") %>');
				// var userId = '<%= @user.id %>';
				// var perPage = '<%= @per_page %>';
				// var userEmail = '<%= current_user.email %>';
				// var totalCount = '<%= @karma_live_items_count %>';
				// UserProfile.init(userId, perPage, totalCount, userEmail);
				UserProfile.infiniteScrolling();
				ComplimentUI.stickyNewCompliment();
				break;
			default:
		}
	}
}
