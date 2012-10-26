module ApplicationHelper

  def link_to_submit(text, css_class=nil)
    link_to_function text, "$(this).closest('form').submit()", :class => css_class
  end

  def site_url
    return "http://www.complimentkarma.com/"
  end

  def title(title)
    return title || "ComplimentKarma"
  end

  def home_link(text, admin_ind=nil)
    html = nil
    if admin_ind
      html = link_to text, admin_path
    elsif current_user
      html = link_to(text, current_user)
    else
      html = link_to(text, root_path)
    end
  end

  def get_mike
    return "Mike"
  end

  def length_of_comment
    return 200
  end
  
  def get_image(path)
    if path
      image_tag(path, :size => "60x60")
    else
      image_tag('/photos/thumb/missing.png')
    end 
  end

  def get_accomplishment_image(path)
    logger.info("Path: #{path}")
    if path
      image_tag(path)
    else
      image_tag('/photos/thumb/missing.png')
    end 
  end

   def get_user_full_name(user)
    if user
      return user.full_name
    else
      return "Unknown User"
    end
  end

  def get_update_user_full_name(item, user=nil)
    logger.info("Update History: #{item.inspect}")
    if user.blank?
      if item && 
         item.recognition_type_id == RecognitionType.ACCOMPLISHMENT.id &&
         item.try(:update_history_type_id) != UpdateHistoryType.Like_Accomplishment.id
        user = item.user
      else
        user = item.try(:originating_user)
      end
    end
    if user
      return user.full_name
    else
      return "Unknown User"
    end
  end

  def get_user_photo_thumb(item, user=nil)
    if user.blank?
      if item && item.recognition_type_id == RecognitionType.ACCOMPLISHMENT.id
        user = item.user
      else
        user = item.originating_user
      end
    end
    if user
      image_tag(user.photo.url(:thumb))
    else
      image_tag('/photos/thumb/missing.png')
    end 
  end

  def get_user_photo_small(user)
    if user
      image_tag(user.photo.url(:small))
    else
      image_tag('/photos/small/missing.png')
    end 
  end

  def get_user_photo_link_mini(user)
    if user
      get_user_photo_link(user, :mini)
    else
      "<img src=/photos/profile/missing.png>".html_safe
    end
  end

  def get_user_photo_link_small(user)
    if user
      get_user_photo_link(user, :small)
    else
      "<img src=/photos/profile/missing.png>".html_safe
    end
  end

  def get_user_photo_link_profile(user)
    if user
      get_user_photo_link(user, :profile)
    else
      "<img src=/photos/profile/missing.png>".html_safe
    end
  end

  def get_user_photo_link_medium(user)
    if user
      get_user_photo_link(user, :medium)
    else
      image_tag('/photos/medium/missing.png', :width => '200')
    end 
  end

  def get_user_photo_link(user, size)
    html = "<a href=/users/#{user.id} class='popup-like-item' title='#{user.first_last}'>"
    html += "<img alt='#{user.first_last}' src=#{user.photo.url(size.to_sym)} style='max-width: 200'>"
    html += "</a>"
    return html.html_safe
  end

  def date_format_month_day(date)
    date = DateUtil.get_local(date)
    if date
      return date.strftime("%b %-d")
    else
      return ""
    end
  end

  def date_time_format(date)
    date = DateUtil.get_central_time(date)
    today = DateUtil.get_central_time(DateTime.now)
    if date
      if date.day == today.day && date.month == today.month && date.year == today.year
        return date.strftime("Today <br />%I:%M %P").html_safe
      elsif date.year == today.year
        return date.strftime("%-m/%d")
      else
        return date.strftime("%-m/%d/%Y")
      end
    else
      return ""
    end
  end

  def timestamp(date)
    # DateUtil.get_local(date)
    return DateUtil.get_time_gap(date)
  end

  def update_history_count_display
    html = ""
    count = update_history_count
    if count < 10
      html += '<div class="single-digit">'
      html += count.to_s
      html += '</div>'
    else
      html += '<div class="double-digit">'
      html += count.to_s
      html += '</div>'
    end

    return html.html_safe
  end

  def update_history_count
    UpdateHistory.find_all_by_user_id(current_user.id).count
  end

  def search_types
    return "<option>People</option><option>Businesses</option>".html_safe
  end

  def social_link(recognition)
    url = recognition.public_url.blank? ? 'http://www.complimentkarma.com' : recognition.public_url
    return url.html_safe
  end

  def state_list
    ListOfStates.list
  end

  def country_list
    ListOfCountries.list
  end

end
