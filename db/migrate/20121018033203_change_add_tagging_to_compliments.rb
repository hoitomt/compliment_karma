class ChangeAddTaggingToCompliments < ActiveRecord::Migration
  def change
    compliments = Compliment.all
    compliments.each do |c|
      next if c.receiver_user_id.blank?
      tags = c.tags
      next if tags.size == 2

      rg = c.get_receiver_group_from_compliment_type
      sg = c.get_sender_group_from_compliment_type
      if tags.size == 1
        if tags[0].group_id = sg.id
          Tag.create_from_compliment(c, rg)
        else
          Tag.create_from_compliment(c, sg)
        end
      else
        Tag.create_from_compliment(c, rg)
        Tag.create_from_compliment(c, sg)
      end
    end
  end
  
end
