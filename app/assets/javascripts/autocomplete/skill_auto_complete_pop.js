var SkillAutoCompletePop = {
	init: function() {
		this.registerHandler();
	},
	registerHandler: function() {
		$('input#pop_compliment_skill_id').unbind('input');
		$('input#pop_compliment_skill_id').bind('input', function(event) {
			setTimeout("SkillAutoCompletePop.searchFx()", 400);
			event.stopPropagation();
		});
		$('html').click(function() {
			SkillAutoCompletePop.hideResults();
		});
	},
	searchFx: function() {
		var searchString = $('input#pop_compliment_skill_id').val();
		var results = SkillAutoCompletePop.ajaxSearch(searchString);
		if(searchString.length == 0) {
			SkillAutoCompletePop.hideResults();
		} else if(results && results.length > 0) {
			SkillAutoCompletePop.showResults(results, searchString);
		} else {
			SkillAutoCompletePop.hideResults();
		}
	},
	showResults: function(results, searchString) {
		var displayResults = SkillAutoCompletePop.formatResults(results, searchString);
		$('#skill-auto-complete-pop-results').html(displayResults);
		SkillAutoCompletePop.setResultClickHandlers();
		$('#skill-auto-complete-pop').show();
	},
	hideResults: function() {
		$('#skill-auto-complete-pop').hide();
	},
	ajaxSearch: function(searchString) {
		$.ajax({
			url: '/search/skills',
			data: {'search_string' : searchString, 'popup' : 'true'}
		});
	},
	formatResults: function(results, searchString) {
		var result = '<ul id="register-me">';
		$.each(results, function(i, val) {
			var formattedResult = SkillAutoCompletePop.highlightSearchString(val, searchString);
			result += "<li>" + formattedResult + "</li>";
		})
		result += "</ul>";
		return result;
	},
	highlightSearchString: function(result, searchString) {
		if( result == null || result == undefined || 
				searchString == null || searchString == undefined) {
			return;
		}
		var length = searchString.length;
		var start = result.toLowerCase().indexOf(searchString.toLowerCase());
		var replaceMe = result.substring(start, start + length);
		var formattedResult = result.replace(replaceMe, '<strong>' + replaceMe + '</strong>');
		return formattedResult;
	},
	setResultClickHandlers: function() {
		$('#register-me').off('click');
		$('#register-me').on({
			click: function() {
				var value = $(this).html();
				var formattedValue = value.replace('<strong>', '');
				formattedValue = formattedValue.replace('</strong>', '');
				$('input#pop_compliment_skill_id').val(formattedValue);
				SkillAutoCompletePop.hideResults();
			}
		}, 'li')
	}
}