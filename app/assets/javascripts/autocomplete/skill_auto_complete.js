var SkillAutoComplete = {
	init: function() {
		this.registerHandler();
	},
	registerHandler: function() {
		$('input#compliment_skill_id').unbind('input');
		$('input#compliment_skill_id').bind('input', function(event) {
			setTimeout("SkillAutoComplete.searchFx()", 400);
			event.stopPropagation();
		});
		$('html').click(function() {
			SkillAutoComplete.hideResults();
		});
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
	}
}