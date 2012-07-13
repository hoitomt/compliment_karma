var InlineForms = {
	init: function() {
		this.setExperienceStateVisibility();
		this.setUserStateVisibility();
		this.setHandlers();
	},
	setHandlers: function() {
		$('select#experience_country').change(function() {
			InlineForms.setExperienceStateVisibility();
		});
		$('select#user_country').change(function() {
			InlineForms.setUserStateVisibility();
		});
	},
	setExperienceStateVisibility: function() {
		var selectedValue = $('select#experience_country').val();
		if(selectedValue == "United States") {
			$('.experience-state-code').show();
		} else {
			$('.experience-state-code').hide();
		}
	},
	setUserStateVisibility: function() {
		var selectedValue = $('select#user_country').val();
		if(selectedValue == "United States") {
			$('.user-state-code').show();
		} else {
			$('.user-state-code').hide();
		}
	}
}