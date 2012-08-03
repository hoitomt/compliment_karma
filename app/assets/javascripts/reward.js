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
		$('select#filter_time_period').off('change');
		$('select#filter_time_period').change(function() {
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
		$('input.reward-amount').change(function() {
			Reward.setCartTotalAmount();
		});
		$('#ajax-submit').unbind('click');
		$('#ajax-submit').click(function(event) {
			event.stopPropagation();
			var formData = $("#reward-add-to-cart-form").serialize()
			$.ajax({
				url: "/rewards/add_to_cart.js",
				type: "POST",
				data: formData
			});
			return false;
		});
	},
	setAlternatingRows: function() {
		$('#select-reward-results tr:nth-child(even)').addClass('alternate');
	},
	updateCartCount: function(countContent) {
		$('#shopping-cart').html(countContent);
	},
	setCartTotalAmount: function() {
		var sum = Reward.cartTotalAmount();
		$('#total-reward-amount').html('$' + sum.toFixed(2));
	},
	cartTotalAmount: function() {
		var sum = 0;
		$('.reward-amount').each(function() {
			var fieldAmount = $(this).val();
			if(fieldAmount == undefined || fieldAmount == null || fieldAmount.length == 0) {
				fieldAmount = $(this).text();
			}
			if(fieldAmount.length > 0 && !isNaN(fieldAmount)) {
				sum += parseFloat(fieldAmount);
			}
		});
		return sum;
	}

}