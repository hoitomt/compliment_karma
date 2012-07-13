class Experience < ActiveRecord::Base
	belongs_to :user

	validates :company, :presence => true
	validates :title, :presence => true
	validate :start_date_is_before_end_date

  default_scope :order => 'end_date DESC'

  def start_date_is_before_end_date
  	return if self.start_date.blank? && self.end_date.blank? #it's ok if they are both blank
  	if self.start_date.blank? && !self.end_date.blank?
  		errors.add(:start_date, "can not be blank when the end date is set")
  	elsif self.start_date >= self.end_date
  		errors.add(:end_date, "can not be prior to the start date")
  	end
  end

end
