class DateUtil

  def self.get_local(d)
    n = DateTime.now
    if d.utc_offset != n.utc_offset
      return d + n.utc_offset
    else
      return d
    end
  end
  
  def self.get_previous_monday_at_zero_time
    d = DateTime.now
    get_monday_at_zero_time(d)
  end
  
  def self.get_monday_at_zero_time(date)
    date = get_local(date)
    if date.monday?
      return get_zero_time(date)
    else
      return get_monday_with_zero_time(date)
    end
  end
  
  def self.get_zero_time(date)
    date = get_local(date)
    DateTime.new(date.year, date.month, date.day, 0, 0, 0)
  end
  
  def self.get_monday_with_zero_time(date)
    date = get_local(date)
    while !date.monday?
      date = date - 1.day
    end
    return get_zero_time(date)
  end
  
  def self.get_time_gap(d)
    # d = get_local(d)
    t1 = Time.now.localtime
    t2 = d.to_time.localtime
    time_gap(t1, t2)
  end
  
  def self.time_gap(t1,t2)
    delta = t1 - t2
    seconds = delta % 60
    delta = (delta - seconds) / 60
    if(delta <= 0.0)
      return "#{seconds.to_i} s"
    end
    minutes = delta % 60
    delta = (delta - minutes) / 60
    if(delta <= 0.0)
      return "#{minutes.to_i} m"
    end
    hours = delta % 24
    delta = (delta - hours) / 24
    if(delta <= 0.0)
      return "#{hours.to_i}h"
    end
    return t2.strftime("%b %-d")
  end
  
end