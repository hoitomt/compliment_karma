module PagesHelper
  def new_invitation_email(count)
    return "multi_invitation[email#{count}]"
  end

  def receiving_email
  	Domain.receiving_email
  end
end
