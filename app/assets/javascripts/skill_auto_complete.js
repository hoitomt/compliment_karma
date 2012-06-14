var SkillAutoComplete = {
	parameters: {
		skillsArray: new Array()
	},
	init: function(skills) {
		this.parameters.skillsArray = skills;
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
		console.log("Fire");
		var searchString = $('input#compliment_skill_id').val();
		var results = SkillAutoComplete.ajaxSearch(searchString);
		// var results = SkillAutoComplete.search(searchString);
		if(searchString.length == 0) {
			SkillAutoComplete.hideResults();
		} else if(results && results.length > 0) {
			SkillAutoComplete.showResults(results);
		} else {
			SkillAutoComplete.hideResults();
		}
	},
	showResults: function(results) {		
		var displayResults = SkillAutoComplete.formatResults(results);
		$('#skill-auto-complete-results').html(displayResults);
		SkillAutoComplete.setResultClickHandlers();
		$('#skill-auto-complete').show();
	},
	hideResults: function() {
		$('#skill-auto-complete').hide();
	},
	search: function(searchString) {
		results = [];
		$.each(SkillAutoComplete.parameters.skillsArray, function(i, val) {
			if(val.toLowerCase().indexOf(searchString.toLowerCase()) >= 0) {
				results.push(val);
			}
			// Load max of 10 results
			if(results.length > 10) {
				return false;
			}
		});
		return results;
	},
	ajaxSearch: function(searchString) {
		$.ajax({
			url: '/search_skills',
			data: {'search_string' : searchString}
		});
	},
	formatResults: function(results) {
		result = '<ul id="register-me">';
		$.each(results, function(i, val) {
			result += "<li>" + val + "</li>";
		})
		result += "</ul>";
		return result;
	},
	setResultClickHandlers: function() {
		$('#register-me').off('click');
		$('#register-me').on({
			click: function() {
				$('input#compliment_skill_id').val($(this).html());
				SkillAutoComplete.hideResults();
			}
		}, 'li')
	}
}