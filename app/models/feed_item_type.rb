class FeedItemType
  attr_accessor :id, :name
  
  def initialize(id, name)
    @id = id
    @name = name
  end
  
  def self.get_feed_item_types
    a = [FeedItemType.new(1, 'All Updates'), 
         FeedItemType.new(2, 'Only Rewards'),
         FeedItemType.new(3, 'Only Compliments'),
         FeedItemType.new(4, 'Only Badges and Trophies')]
  end
  
  def self.ALL_UPDATES
    FeedItemType.new(1, 'All Updates')
  end
  
  def self.ONLY_REWARDS
    FeedItemType.new(2, 'Only Rewards')
  end
  
  def self.ONLY_COMPLIMENTS
    FeedItemType.new(3, 'Only Compliments')
  end
  
  def self.ONLY_ACCOMPLISHMENTS
    FeedItemType.new(4, 'Only Badges and Trophies')
  end
  
end