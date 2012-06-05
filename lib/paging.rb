class Paging
  ## default per page = 10 items
  def self.page(array, page=nil, per_page=nil)
    per_page ||= 10
    page ||= 1
    end_index = page.to_i * per_page.to_i
    start_index =  end_index - per_page.to_i
    if start_index > array.size
      return nil
    elsif end_index > array.size
      end_index = array.size
    end
    return array[start_index..end_index - 1]
  end
end