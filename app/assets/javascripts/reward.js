var Reward = {
	init: function() {
		this.setDatePickers();
		this.setHandlers();
		this.setAlternatingRows();
	},
	setDatePickers: function() {
		$('#filter_as_of_date').datepicker();
		$('#filter_stop_date').datepicker();
	},
	setHandlers: function() {
		$('select#filter_time_period_type').off('change');
		$('select#filter_time_period_type').change(function() {
			var selectedOption = $(this).val();
			var stopDate = $('#show-stop-date');
			if(selectedOption == "Between") {
				stopDate.show();
			} else {
				stopDate.hide();
			}
		});
		$('select#department_filter').off('change');
		$('select#department_filter').change(function() {
			var departmentId = $(this).val();
			var companyUserId = $('#company_user_id').val();
			$.ajax({
				url: '/users/' + companyUserId + '/rewards.js',
				type: 'POST',
				data: {department_id: departmentId}
			})
		});
		
	},
	setAlternatingRows: function() {
		console.log("stuff");
		$('#select-reward-results tr:nth-child(even)').addClass('alternate');
	}
}