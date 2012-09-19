class Tag < ActiveRecord::Base
	belongs_to :compliment, :foreign_key => :recognition_id,
													:conditions => {:recognition_type_id => RecognitionType.COMPLIMENT.id}
	belongs_to :reward, :foreign_key => :recognition_id,
											:conditions => {:recognition_type_id => RecognitionType.REWARD.id}
	belongs_to :accomplishment, :foreign_key => :recognition_id,
															:conditions => {:recognition_type_id => RecognitionType.ACCOMPLISHMENT.id}
  belongs_to :group

  validates_presence_of :recognition_id, :recognition_type_id, :group_id

  validates_uniqueness_of :group_id, :scope => [:recognition_type_id, :recognition_id],
  																				:message => "The item has already been tagged"

  def self.create_from_compliment(compliment, group)
  	create(:recognition_id => compliment.id,
  				 :recognition_type_id => RecognitionType.COMPLIMENT,
  				 :group_id => group.id)
  end

end
