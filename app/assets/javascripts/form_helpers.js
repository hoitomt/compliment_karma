var FormHelpers = {
	init: function() {
		this.hideSignUpHelpers();
		this.addHandlers();
	},
	addHandlers: function() {
		$('#user_email').focus(function() {
			$('#user_email_helper').show(200);
		});
		$('#user_email').blur(function() {
			$('#user_email_helper').hide(200);
		});
		
		$('#user_name').focus(function() {
			$('#user_name_helper').show(200);
		});
		$('#user_name').blur(function() {
			$('#user_name_helper').hide(200);
		});
		
		$('#user_job_title').focus(function() {
			$('#user_job_title_helper').show(200);
		});
		$('#user_job_title').blur(function() {
			$('#user_job_title_helper').hide(200);
		});
		
		$('#user_password').focus(function() {
			$('#user_password_helper').show(200);
		});
		$('#user_password').blur(function() {
			$('#user_password_helper').hide(200);
		});	
	},
	hideSignUpHelpers: function() {
		$('#user_email_helper').hide();
		$('#user_name_helper').hide();
		$('#user_job_title_helper').hide();
		$('#user_password_helper').hide();
	}
}

