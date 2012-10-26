module RecognitionHelper
  def og_meta_title(recognition)
    if recognition.is_compliment?
      c = recognition.compliment
      if c.blank? || c.receiver.blank?
        @title = "ComplimentKarma - Compliment"
      else
        @title = "Compliment from #{c.sender.first_last} to #{c.receiver.first_last}"
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
    if recognition.is_compliment?
      return "compliment"
    elsif recognition.is_reward?
      return "reward"
    elsif recognition.is_accomplishment?
      return "accomplishment"
    end
  end

  def og_meta_description(recognition)
    if recognition.is_compliment?
    elsif recognition.is_reward?
    elsif recognition.is_accomplishment?
    end
  end

end
