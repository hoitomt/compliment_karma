var SkillAutoComplete = {
	parameters: {
		skillsArray: new Array()
	},
	init: function(skills) {
		this.parameters.skillsArray = skills;
		console.log(this.parameters.skillsArray);
		this.registerHandler();
	},
	registerHandler: function() {
		$('input#compliment_skill').bind('input', function(event) {
			var searchString = $(this).val();
			console.log(searchString);
			var results = SkillAutoComplete.search(searchString);
			console.log(results.length);
			if(results && results.length > 0) {
				var displayResults = SkillAutoComplete.formatResults(results);
				$('#skill-auto-complete-results').html(displayResults);
				SkillAutoComplete.showResults();
				SkillAutoComplete.setResultClickHandlers();
			}
			event.stopPropagation();
		});
		$('html').click(function() {
			SkillAutoComplete.hideResults();
		});
	},
	showResults: function() {
		$('#skill-auto-complete').show();
	},
	hideResults: function() {
		$('#skill-auto-complete').hide();
	},
	search: function(searchString) {
		results = [];
		$.each(this.parameters.skillsArray, function(i, val) {
			if(val.toLowerCase().indexOf(searchString.toLowerCase()) >= 0) {
				results.push(val);
			}
		});
		return results;
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
		console.log('set result click handlers');
		$('#register-me').off('click');
		$('#register-me').on({
			click: function() {
				console.log($(this).html());
				$('input#compliment_skill').val($(this).html());
				SkillAutoComplete.hideResults();
			}
		}, 'li')
	}
}