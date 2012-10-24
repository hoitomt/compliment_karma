class PopulateRecognitionTable < ActiveRecord::Migration
  def change
    p "Create recognition from compliment"
    Compliment.all.each do |c|
      Recognition.create_from_compliment(c)
    end

    p "Create recognition from reward"
    Reward.all.each do |r|
      Recognition.create_from_reward(r)
    end

    p "Create recognition from accomplishment"
    Accomplishment.all.each do |a|
      Recognition.create_from_accomplishment(a)
    end

  end

end
