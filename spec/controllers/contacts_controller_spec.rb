require 'spec_helper'

describe ContactsController do
	render_views

	let(:user2){ FactoryGirl.create(:user2) }
  let(:user3){ FactoryGirl.create(:user3) }

  before(:each) do
    @new_title = "Sign up"
    controller.class.skip_before_filter :shell_authenticate
  end

  
end
