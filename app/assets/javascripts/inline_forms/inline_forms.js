var InlineForms = {
	init: function() {
		this.setExperienceStateVisibility();
		this.setUserStateVisibility();
		this.setCompanyStateVisibility();
		this.setHandlers();
	},
	setHandlers: function() {
		$('select#experience_country').change(function() {
			InlineForms.setExperienceStateVisibility();
		});
		$('select#user_country').change(function() {
			InlineForms.setUserStateVisibility();
		});
		$('select#company_country').change(function() {
			InlineForms.setCompanyStateVisibility();
		});
	},
	setExperienceStateVisibility: function() {
		var selectedValue = $('select#experience_country').val();
		if(selectedValue == "United States") {
			$('input#_state_cd_txt').val('')
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
			$('input#_state_cd_txt').val('');
			$('.user-state-code-select').show();
			$('.user-state-code-text').hide();
		} else {
			$('.user-state-code-select').hide();
			$('.user-state-code-text').show();
		}
	},
	setCompanyStateVisibility: function() {
		var selectedValue = $('select#company_country').val();
		if(selectedValue == "United States") {
			$('input#_state_cd_txt').val('');
			$('.company-state-code-select').show();
			$('.company-state-code-text').hide();
		} else {
			$('.company-state-code-select').hide();
			$('.company-state-code-text').show();
		}
	}
}