module PagesHelper
  def new_invitation_email(count)
    return "multi_invitation[email#{count}]"
  end
end
