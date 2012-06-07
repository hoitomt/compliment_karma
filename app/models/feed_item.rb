class FeedItem
  
  attr_accessor :sort_date, :item_type_id, :item_object
  
  def initialize(sort_date, item_type_id, item)
    @sort_date = sort_date
    @item_type_id = item_type_id
    @item_object = item
  end
  
  def self.construct_items(compliments=nil, rewards=nil, accomplishments=nil)
    h = {} # key = sort_date, value = FeedItem obj
    rt_compliment_id = RecognitionType.COMPLIMENT.id
    rt_reward_id = RecognitionType.REWARD.id
    rt_accomplishment_id = RecognitionType.ACCOMPLISHMENT.id

    if compliments
      compliments.each do |compliment|
        h[compliment.updated_at] = FeedItem.new(compliment.updated_at, rt_compliment_id, compliment)
      end
    end

    if rewards
      rewards.each do |user_reward|
        h[user_reward.updated_at] = FeedItem.new(user_reward.updated_at, rt_reward_id, user_reward)
      end
    end

    if accomplishments
      accomplishments.each do |user_a|
        h[user_a.updated_at] = FeedItem.new(user_a.updated_at, rt_accomplishment_id, user_a)
      end
    end

    hs = h.sort_by{ |k,v| k }.reverse
  end
  
end