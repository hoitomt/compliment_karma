module ApplicationHelper

  def site_url
    return "http://fierce-sunset-4672.herokuapp.com/"
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

  def timestamp(date)
    return DateUtil.get_time_gap(date)
  end
  
  def get_image(path)
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

  def get_user_photo_thumb(user)
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
      link_to image_tag(user.photo.url(:mini)), 
              user_path(user.id), 
              :class => "popup-like-item",
              :title => "#{user.full_name}"
    else
      image_tag('/photos/mini/missing.png')
    end 
  end

  def get_user_photo_link_small(user)
    if user
      link_to image_tag(user.photo.url(:small)), user_path(user.id)
    else
      image_tag('/photos/small/missing.png')
    end 
  end

  def get_user_photo_link_profile(user)
    if user
      link_to image_tag(user.photo.url(:profile), :style => "max-width: 200"), user_path(user.id)
    else
      image_tag('/photos/profile/missing.png')
    end 
  end

  def get_user_photo_link_medium(user)
    if user
      link_to image_tag(user.photo.url(:medium), :style => "max-width: 200"), user_path(user.id)
    else
      image_tag('/photos/medium/missing.png', :width => '200')
    end 
  end

  def date_format_month_day(date)
    if date
      return date.strftime("%b %-d")
    else
      return ""
    end
  end

  def date_time_format(date)
    today = DateTime.now
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

  def social_link(recognition_type_id, recognition_id)
    return "#{site_url}recognition/#{recognition_type_id}/#{recognition_id}".html_safe
  end

  def state_list
    ListOfStates.list
  end

  def country_list
    ListOfCountries.list
  end

end
