module UsersHelper
  
  def set_active (active, arrow_number)
    return "active" if active == "slide#{arrow_number}"
    return "inactive"
  end
  
  def compliment_text(compliment)
    if compliment.nil? || compliment.comment.nil? || compliment.comment.blank?
      return "A comment was not entered for this compliment"
    else
      return compliment.comment
    end
  end

  def compliment_type(compliment)
    if compliment && compliment.compliment_type
      html = '<span style="margin-right: 15px">'
      html << compliment.compliment_type.name
      html << '</span>'
      return html.html_safe
    end
  end

  def compliment_skill(compliment)
    if compliment && compliment.skill_id
      skill = Skill.find_by_id(compliment.skill_id)
      return skill.name unless skill.blank?
    end
  end
  
  def compliment_status(compliment)
    if compliment.compliment_status
      return compliment.compliment_status.name
    else
      return "not specified"
    end
  end

  def account_status_display(confirmed, pending_items)
    return "" unless current_user?(@user)
    if confirmed
      if pending_items && pending_items.any?
        return "pending"
      end
    else
      return "not-confirmed"
    end
  end

  def pending_relationship_display(user)
    html = "Compliment from #{user.full_name}"
    html += " #{user.city}," if user.city
    html += " #{user.state_cd}" if user.state_cd
    html += " (#{user.email})"
    return html.html_safe
  end
  
  def tooltip(compliment)
    html = "sender: #{compliment.sender_email}\n"
    html += "receiver: #{compliment.receiver_email}\n"
    html += "status: #{compliment_status(compliment)}\n"
    html += "visibility: #{compliment.visibility.name}\n"
    sender = User.find_by_id(compliment.sender_user_id)
    if sender
      html += "sender status: #{sender.account_status.name}"
    else
      html += "sender status: Unregistered"
    end
    html += "\n"
    receiver = User.find_by_id(compliment.receiver_user_id)
    if receiver
      html += "receiver status: #{receiver.account_status.name}"
    else
      html += "receiver status: Unregistered"
    end
  end
  
  def get_content_for_recent_compliments(compliments_since_last_monday, index)
    if (index + 1 <= compliments_since_last_monday.size)
      receiver = compliments_since_last_monday[index].get_receiver
      if receiver
        html = link_to image_tag(receiver.photo.url(:mini), :size => "30x30"), receiver
      else
        html = image_tag('/photos/mini/missing.png', :size => "30x30")
      end
    else
      html = (index + 1).to_s
    end
		return html
  end
  
  def get_likes_count(item_object_id, recognition_type_id)
    count = CkLike.get_count(item_object_id, recognition_type_id)
    return count_display(count)
  end

  def display_likes_header_count(count)
    if count.blank?
      return "No Likes at this time"
    elsif count == 1
      return "#{count} Like"
    else
      return "#{count} Likes"
    end
  end
  
  def get_comments_count(item_object, recognition_type_id)
    count = RecognitionComment.get_count(item_object.id, recognition_type_id)
    return count_display(count)
  end
  
  def get_like_status(recognition_id, recognition_type_id)
    logger.info("Recognition ID: #{recognition_id}")
    logger.info("Recognition Type ID: #{recognition_type_id}")
    logger.info("User ID: #{current_user.id}")
    return CkLike.get_like_status(recognition_id, recognition_type_id, current_user.id)
  end

  def like_button(recognition_id, recognition_type_id)
    return if recognition_id.nil? || recognition_type_id.nil?
    status = get_like_status(recognition_id, recognition_type_id)
    logger.info("Like Status: #{status}")
    if status == CkLike.UNLIKE
      button_text = "Unlike"
      button_class = "unlike-button"
      # img = image_tag('buttons/Button_Unlike.png')
    else
      # button_text = '<font style="font-weight:bold;">♥</font>'
      button_text = "&hearts; Like"
      button_class = "like-button"
      # img = image_tag('buttons/Button_Like.png')
    end
    logger.info("Button Class: #{button_class}")
    # return link_to img, ck_likes_path(:recognition_type_id => recognition_type_id,
    #                                   :recognition_id => recognition_id,
    #                                   :count => @count,
    #                                   :user_id => current_user.id),
    #                     :method => :post,
    #                     :remote => true,
    #                     :id => "like-button"
    return link_to button_text.html_safe, ck_likes_path(:recognition_type_id => recognition_type_id,
                                      :recognition_id => recognition_id,
                                      :count => @count,
                                      :user_id => current_user.id),
                        :method => :post,
                        :remote => true,
                        :class => button_class
  end

  def likes_link(recognition_id, recognition_type_id)
    label = get_like_status(recognition_id, recognition_type_id)
    count = get_likes_count(recognition_id, recognition_type_id)
    return link_to "#{label}#{count}", 
                    ck_likes_path(:recognition_type_id => recognition_type_id,
                                  :recognition_id => recognition_id,
                                  :count => @count,
                                  :user_id => current_user.id),
                    :method => :post,
                    :remote => true
  end

  def comments_link(feed_item)
    label = "Comment"
    count = get_comments_count(feed_item.item_object, feed_item.item_type_id)
    return link_to "#{label}#{count}",
                   show_recognition_detail_path(:recognition_type_id => feed_item.item_type_id,
                                                :recognition_id => feed_item.item_object.id,
                                                :count => @count,
                                                :user_id => current_user.id),
                   :remote => true,
                   :id => "comment-count-#{@count}"
  end

  def compliments_link(feed_item, link_text)
    if feed_item && feed_item.item_type_id == @recognition_type_compliment.id
      if link_text =~ /Sender/
        return link_to link_text, 
                       new_compliment_path(:recipient_id => feed_item.item_object.sender_user_id),
                                           :remote => true
      elsif link_text =~ /Receiver/
        return link_to link_text, 
                        new_compliment_path(:recipient_id => feed_item.item_object.receiver_user_id),
                                            :remote => true
      else
        link_to link_text, new_compliment_path, :remote => true
      end
    elsif feed_item && feed_item.item_type_id == @recognition_type_reward.id
      return link_to link_text, new_compliment_path(:recipient_id => feed_item.item_object.receiver_id),
                                                    :remote => true
    else
      return link_to link_text, new_compliment_path(:recipient_id => feed_item.item_object.user_id),
                                                    :remote => true
    end
  end

  def compliment_button_medium(user=nil)
    # compliment_button(user, 'medium-button')
    compliment_button(user)
  end

  def compliment_button_large(user=nil)
    # compliment_button(user, 'large-button')
    compliment_button(user)
  end

  def compliment_button(user=nil, button_class=nil)
    if user && user.id == current_user.id
      return ""
    elsif user && user.id != current_user.id
      return link_to "Compliment", 
                     new_compliment_path(:recipient_id => user.id), 
                     :class => "compliment-button #{button_class}",
                     :remote => true
    else
      return link_to "Compliment", 
                     new_compliment_path, 
                     :class => "compliment-button #{button_class}",
                     :remote => true      
    end
  end

  def follows_button_medium(user=nil)
    return "" if user.nil?
    # follows_button(user.id, "medium-button")
    follows_button(user.id)
  end

  def follows_button_large(user=nil)
    return "" if user.nil?
    # follows_button(user.id, "large-button")
    follows_button(user.id)
  end

  def follows_button(user_id=nil, button_size_class=nil)
    return "" if user_id == current_user.id
    if user_id
      button_class = "popup-button #{button_size_class}"
      button_text = "Follow"
      if follow_exists?(user_id)
        button_class = "popup-button popup-button-following #{button_size_class}"
        button_text = "Following"
      end
      return follows_button_link(user_id, button_text, button_class)
    end
  end

  def follows_button_link(user_id, button_text, button_class=nil)
    return link_to button_text, follows_path(:subject_user_id => user_id,
                                         :follower_user_id => current_user.id),
                                :method => :post,
                                :class => 'follow-button',
                                :remote => true
  end

  def follows_link(feed_item, link_text=nil)
    if feed_item.item_type_id == @recognition_type_compliment.id
      if link_text =~ /Sender/
        return follow_single_link(feed_item.item_object.sender_user_id, "Sender")
      elsif link_text =~ /Receiver/
        return follow_single_link(feed_item.item_object.receiver_user_id, "Receiver")
      else
        return "Follow"
      end
    elsif feed_item.item_type_id == @recognition_type_reward.id
      return follow_single_link(feed_item.item_object.receiver_id, "Follow")
    else
      return follow_single_link(feed_item.item_object.user_id, "Follow")
    end
  end

  def follow_single_link(subject_id, link_text)
    unfollow = link_text
    if follow_exists?(subject_id)
      unfollow = "Following #{link_text}"
    elsif subject_id == current_user.id
      return
    end
    link_to unfollow, 
            follows_path(:subject_user_id => subject_id,
                         :follower_user_id => current_user.id),
                         :method => :post
  end

  def follow_exists?(subject_id)
    follow_exists = Follow.follow_exists?(subject_id, current_user.id)
  end

  def follow_multi_link(feed_item)
    link_to 'Both', 
            multi_create_follows_path(:subject1_user_id => feed_item.item_object.receiver_user_id,
                                      :subject2_user_id => feed_item.item_object.receiver_user_id,
                                      :follower_user_id => current_user.id)
  end

  def count_display(count)
    if count > 0
      return "(#{count})"
    else
      return ""
    end
  end
  
  def ajax_helpers_standard(feed_item, count)
    html = hidden_field_tag "recognition-id", feed_item.item_object.id
    html += hidden_field_tag "count-id", count
    html += hidden_field_tag "current-user-id", current_user.id
  end

  def ajax_helpers_compliment(feed_item, count)
    html = ajax_helpers_standard(feed_item, count)
    html += hidden_field_tag "recognition-type-id", RecognitionType.COMPLIMENT.id
    html += hidden_field_tag "sender-user-id", feed_item.item_object.sender_user_id
    html += hidden_field_tag "receiver-user-id", feed_item.item_object.receiver_user_id
    html += hidden_field_tag "user-id", current_user.id
  end
  
  def ajax_helpers_reward(feed_item, count)
    html = ajax_helpers_standard(feed_item, count)
  	html += hidden_field_tag "recognition-type-id", RecognitionType.REWARD.id
    html += hidden_field_tag "user-id", feed_item.item_object.receiver_id
  end
  
  def ajax_helpers_accomplishment(feed_item, count)
    html = ajax_helpers_standard(feed_item, count)
  	html += hidden_field_tag "recognition-type-id", RecognitionType.ACCOMPLISHMENT.id
    html += hidden_field_tag "user-id", feed_item.item_object.user_id
  end

  def my_update_image(item)
    case item.update_history_type_id
    when UpdateHistoryType.Received_Compliment.id
         return image_tag('my_updates/icon_24x24_compliment.png')
    when UpdateHistoryType.Comment_on_Received_Compliment.id, 
         UpdateHistoryType.Comment_on_Sent_Compliment.id,
         UpdateHistoryType.Comment_on_Reward.id,
         UpdateHistoryType.Comment_on_Accomplishment.id
         return image_tag('my_updates/icon_24x24_callout.png')
    when UpdateHistoryType.Accepted_Compliment_Receiver.id
         return image_tag('my_updates/icon_24x24_greencheck.png')
    when UpdateHistoryType.Rejected_Compliment_Receiver.id
         return image_tag('my_updates/sad_face.png')
    when UpdateHistoryType.Like_Received_Compliment.id, 
         UpdateHistoryType.Like_Sent_Compliment.id
         UpdateHistoryType.Like_Reward.id
         UpdateHistoryType.Like_Accomplishment.id
         return image_tag('my_updates/icon_24x24_heart.png')
    when UpdateHistoryType.Share_Received_Compliment_On_Facebook.id,
         UpdateHistoryType.Share_Sent_Compliment_On_Facebook.id,
         UpdateHistoryType.Share_Reward_on_Facebook.id,
         UpdateHistoryType.Share_Accomplishment_on_Facebook.id
         return image_tag('my_updates/facebook_mini.png')
    when UpdateHistoryType.Share_Received_Compliment_On_Twitter.id,
         UpdateHistoryType.Share_Sent_Compliment_On_Twitter.id,
         UpdateHistoryType.Share_Reward_on_Twitter.id,
         UpdateHistoryType.Share_Accomplishment_on_Twitter.id
         return image_tag('my_updates/twitter_mini.png')
    when UpdateHistoryType.Received_Reward.id
         return get_reward_image(item.recognition_id)
    when UpdateHistoryType.Earned_an_Accomplishment.id
         return get_accomplishment_image(item.recognition_id)
    when UpdateHistoryType.Following_You.id
         return image_tag('my_updates/icon_24x24_heart.png')
    end
  end

  def get_reward_image(id)
    reward = Reward.find_by_id(reward_id)
    return image_tag(reward.image_mini)
  end

  def get_accomplishment_image(id)
    ua = UserAccomplishment.find_by_id(id)
    return image_tag(ua.accomplishment.image_mini)
  end

  def social_url(feed_item)
    recognition_id = feed_item.item_object.id
    recognition_type_id = feed_item.item_type_id
    return social_url_p(recognition_type_id, recognition_id)
  end

  def social_url_p(recognition_type_id, recognition_id)
    domain = "http://fierce-sunset-4672.heroku.com/recognition"
    return "#{domain}/#{recognition_type_id}/#{recognition_id}"
  end

  def presenter_name(reward)
    unless reward.presenter_id.blank?
      return " from #{reward.presenter.full_name}"
    end
  end

  def recognition_left_side(feed_item)
    if feed_item.item_type_id == @recognition_type_compliment.id
      unless feed_item.item_object.sender_user_id.blank?
        return User.find_by_id(feed_item.item_object.sender_user_id).full_name
      end
    elsif feed_item.item_type_id == @recognition_type_reward.id
      unless feed_item.item_object.presenter_id.blank?
        presenter = User.find_by_id(feed_item.item_object.presenter_id)
        return presenter.full_name
      else
        return "Secret Santa"
      end
    elsif feed_item.item_type_id == @recognition_type_accomplishment.id
      return User.find_by_id(feed_item.item_object.user_id).full_name
    end
  end

  def recognition_right_side(feed_item)
    if feed_item.item_type_id == @recognition_type_compliment.id
      unless feed_item.item_object.receiver_user_id.blank?
        return User.find_by_id(feed_item.item_object.receiver_user_id).full_name
      end
    elsif feed_item.item_type_id == @recognition_type_reward.id
      return User.find_by_id(feed_item.item_object.receiver_id).full_name
    elsif feed_item.item_type_id == @recognition_type_accomplishment.id
      # Nothing
    end
  end

  def recognition_arrow(feed_item)
    if feed_item.item_type_id == @recognition_type_accomplishment.id
      return image_tag('user_profile/left_side_receive_arrow.png')
    else
      return image_tag('user_profile/right_side_receive_arrow.png')
    end
  end

  def indicator(feed_item)
    if feed_item.item_type_id == @recognition_type_compliment.id
      c = Compliment.find_by_id(feed_item.item_object.id)
      logger.info("Compliment Type Id #{c.compliment_type_id}")
      case c.compliment_type_id.to_i
      when ComplimentType.COWORKER_TO_COWORKER.id
        return "blue"
      when ComplimentType.PROFESSIONAL_TO_PROFESSIONAL.id
        return "blue"
      when ComplimentType.PROFESSIONAL_TO_PERSONAL.id
        return "blue"
      when ComplimentType.PERSONAL_TO_PROFESSIONAL.id
        return "red"
      when ComplimentType.PERSONAL_TO_PERSONAL.id
        return "red"
      else
        return "blue"
      end
    elsif feed_item.item_type_id == @recognition_type_reward.id
      return "green"
    elsif feed_item.item_type_id == @recognition_type_accomplishment.id
      return "orange"
    end
  end

  def location(user)
    city = ""
    city = "#{user.city}" unless user.city.blank?
    state_cd = ""
    state_cd = user.state_cd unless user.state_cd.blank?
    if city.blank? && state_cd.blank?
      return link_to 'Add location', '#', :class => 'js-click-update-user'
    end
    separator = ', '
    if city.blank? || state_cd.blank?
      separator = ''
    end
    return "#{city}#{separator}#{state_cd}"
  end

  def stats_label(count, label)
    return label.pluralize if count && count > 1 && label
    return label
  end

  def complimenter_rank_image(compliment_count)
    accomplishment = Accomplishment.complimenter_level(compliment_count)
    if accomplishment
      return image_tag(accomplishment.image_thumb, :height => 110)
    end
  end

  def rewarder_rank_image(reward_count)
    accomplishment = Accomplishment.rewarder_level(reward_count)
    if accomplishment
      return image_tag(accomplishment.image_thumb, :height => 110)
    end
  end

  def badge_image(count)
    return "" if count.nil?
    accomplishment = Accomplishment.badge(count)
    if accomplishment
      return image_tag(accomplishment.image_thumb, :class => 'badge')
    end
  end

  def skill_name(id)
    skill = Skill.find_by_id(id)
    logger.info("Skill ID: #{id} - Skill Name: #{skill}")
    skill.name if skill
  end

  def skill_autocomplete_key(id)
    skill = Skill.find_by_id(id)
    logger.info("Skill ID: #{id} - Skill Name: #{skill}")
    parent_skill_key = skill.parent_skill_key if skill
  end

  def upload_background_photo(user)
    if view_state(user) == view_state_company_manager ||
       view_state(user) == view_state_company_visitor
      return "background-image-company"
    elsif view_state(user) == view_state_user_manager ||
          view_state(user) == view_state_user_visitor
      return "background-image-user"
    end
  end

  def new_compliment_heading(user)
    if view_state(user) == view_state_user_manager 
      return "Who deserves your compliment today?"
    elsif view_state(user) == view_state_user_visitor
      return "Send a compliment to #{user.first_name}"
    elsif view_state(user) == view_state_company_visitor
      return "Send a compliment to #{user.company.name}"
    elsif view_state(user) == view_state_company_manager
      return "Who deserves our compliment today?"
    end
  end
end
