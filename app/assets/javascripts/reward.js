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
		$('select#filter_time_period_type').change(function() {
			console.log();
			var selectedOption = $(this).val();
			var stopDate = $('#show-stop-date');
			if(selectedOption == "Between") {
				stopDate.show();
			} else {
				stopDate.hide();
			}
		});
		
	},
	setAlternatingRows: function() {
		console.log("stuff");
		$('#select-reward-results tr:nth-child(even)').addClass('alternate');
	}
}