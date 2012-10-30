module RecognitionHelper

  def og_meta_title(recognition)
    return nil if recognition.blank?
    if recognition.is_compliment?
      c = recognition.compliment
      if c.blank? || c.receiver.blank?
        @title = "ComplimentKarma - Compliment"
      else
        @title = "Compliment from #{c.sender.first_last} to #{c.receiver_name}"
      end
    elsif recognition.is_reward?
      r = recognition.reward
      if r.blank?
        @title = "ComplimentKarma - Reward"
      else
        @title = "Reward from #{r.presenter.first_last} to #{r.receiver.first_last}"
      end
    elsif recognition.is_accomplishment?
      ua = recognition.user_accomplishment
      if ua.blank?
        @title = "ComplimentKarma - Accomplishment"
      else
        @title = "#{ua.user.first_last} has earned a #{ua.accomplishment.name} badge"
      end
    end
  end

  def og_meta_type(recognition)
    return nil if recognition.blank?
    if recognition.is_compliment?
      return "compliment"
    elsif recognition.is_reward?
      return "reward"
    elsif recognition.is_accomplishment?
      return "accomplishment"
    end
  end

  def og_meta_description(recognition)
    # return og_meta_title(recognition)
    return nil if recognition.blank?
    if recognition.is_compliment?
      c = recognition.compliment
      html = "#{c.sender.first_last} complimented #{c.receiver_name} for #{c.skill.name}. "
      html += "#{recognition.public_url} via @ComplimentKarma"
    elsif recognition.is_reward?
      r = recognition.reward
      html = "#{r.receiver.first_last} was rewarded #{r.value} by #{r.presenter.first_last}. "
      html += "#{recognition.public_url} via @ComplimentKarma"
    elsif recognition.is_accomplishment?
      ua = recognition.user_accomplishment
      html = "#{ua.user.first_last} earned a #{ua.accomplishment.name} badge. "
      html += "#{recognition.public_url} via @ComplimentKarma"
    end
    return html.html_safe
  end

  def fb_like_url(recognition)
    return nil if recognition.blank?
    if Rails.env.staging?
      url = "http://ck-dev.herokuapp.com/recognitions/#{recognition.url_token}"
    else
      url = "http://www.complimentkarma.com/recognitions/#{recognition.url_token}"
    end
    return url.html_safe
  end

  def meta_content(recognition)
    if recognition.blank?
      content = "Send / Receive Compliments from your Professional / Social Network. 
                 Build Proof of Experience and Earn your Employer sponsored Rewards"
    else
      content = og_meta_description(recognition)
    end
    return content.html_safe
  end

end
