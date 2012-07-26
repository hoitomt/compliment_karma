var SkillAutoComplete = {
	skillList: null,
	init: function() {
		this.registerHandler();
		// this.setSkillList();
	},
	registerHandler: function() {
		$('input#compliment_skill_id').unbind('input');
		$('input#compliment_skill_id').bind('input', function(event) {
			setTimeout("SkillAutoComplete.searchFx()", 400);
			// SkillAutoComplete.searchLocal();
			event.stopPropagation();
		});
		$('html').click(function() {
			SkillAutoComplete.hideResults();
		});
	},
	searchLocal: function() {
		var searchString = $('input#compliment_skill_id').val();
		var searchEx = new RegExp(searchString, "i");
		console.log(searchEx);
		var results = []
		$.each(SkillAutoComplete.skillList, function(key, value) {
			if(value.match(searchEx)) {
				console.log("match: " + value);
			}
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
				console.log(data);
				SkillAutoComplete.skillList = data;
			}
		});
	}
}