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
			$('.experience-state-code-select').show();
			$('.experience-state-code-text').hide();
		} else {
			$('.experience-state-code-select').hide();
			$('.experience-state-code-text').show();
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