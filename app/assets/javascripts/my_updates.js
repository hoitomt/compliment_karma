var MyUpdates = {
	init: function(){
		this.showMyUpdates();
	},
	showMyUpdates: function() {
		$('#my-updates-link').click(function() {
		})
	},
	updateCount: function(myUpdateCount) {
		// console.log(myUpdateCount);
		var myUpdateCountContainer = $('#update-history-count');
		if(myUpdateCount > 0 ) {
			myUpdateCountContainer.html(myUpdateCount);
			if(!myUpdateCountContainer.hasClass('header-update-count')) {
				myUpdateCountContainer.addClass('header-update-count');
			}
		} else {
			myUpdateCountContainer.html('');
			if(myUpdateCountContainer.hasClass('header-update-count')) {
				myUpdateCountContainer.removeClass('header-update-count');
			}
		}
	}
}