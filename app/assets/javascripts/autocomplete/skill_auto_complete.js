var SkillAutoComplete = {
	skillList: null,
	init: function() {
		this.registerHandler();
		// this.setSkillList();
	},
	registerHandler: function() {
		$('input#compliment_skill_id').off('keyup');
		$('input#compliment_skill_id').on({
			keyup: function(event) {
				setTimeout("SkillAutoComplete.searchFx()", 400);
				// SkillAutoComplete.searchLocal();
				event.stopPropagation();
			}
		});
		$('html').click(function() {
			SkillAutoComplete.hideResults();
		});
	},
	searchLocal: function() {
		var searchString = $('input#compliment_skill_id').val();
		var searchEx = new RegExp(searchString, "i");
		var results = []
		$.each(SkillAutoComplete.skillList, function(key, value) {
			if(value.match(searchEx)) {}
		});
		var results = SkillAutoComplete.ajaxSearch(searchString);
	},
	searchFx: function() {
		var searchString = $('input#compliment_skill_id').val();
		var results = SkillAutoComplete.ajaxSearch(searchString);
	},
	hideResults: function() {
		$('#skill-auto-complete').hide();
	},
	ajaxSearch: function(searchString) {
		$.ajax({
			url: '/search/skills',
			data: {'search_string' : searchString}
		});
	},
	setResultClickHandlers: function() {
		$('#register-me').off('click');
		$('#register-me').on({
			click: function() {
				var value = $(this).html();
				var formattedValue = value.replace('<strong>', '');
				formattedValue = formattedValue.replace('</strong>', '');
				$('input#compliment_skill_id').val(formattedValue);
				SkillAutoComplete.hideResults();
			}
		}, 'li')
	},
	setSkillList: function() {
		return $.ajax({
			url: '/search/skills',
			dataType: "json",
			success: function(data) {
				SkillAutoComplete.skillList = data;
			}
		});
	}
}