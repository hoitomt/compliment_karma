var Admin = {
	init: function() {
		this.setEventHandlers();
	},
	setEventHandlers: function() {
		$('#am-hover-me').off('mouseover, mouseout');
		$('#am-hover-me').on({
			mouseover: function() {
				$('#admin-menu').show();
			},
			mouseout: function() {
				$('#admin-menu').hide();			
			}
		});
		$('#admin-menu').off('mouseover, mouseout');
		$('#admin-menu').on({
			mouseover: function() {
				$(this).show();
			},
			mouseout: function() {
				$(this).hide();
			}
		})
	}
}