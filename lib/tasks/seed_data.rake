namespace :compliment do
  @dummy_email = "dummy@example.org"
  @comments = ["You're awesome!", "I love your work", "Great Job on the Obama Case",
               "Sweet job", "Way to go", "Nice work on that project",
               "Good job", "Awesome", "You're a rockstar!", "You're great",
               "Chicago is a cool city"]
  
  desc "Add some compliments for the dummy user at various visibilities"
  task :add do |cmd, args|
    Rake::Task[:environment].invoke

    homer = User.find_by_email("homerj@springfield.net")
    homer_attr = { :email => "homerj@springfield.net", 
                   :name => "Homer J Simpson", 
                   :password => "maggie",
                   :account_status_id => AccountStatus.CONFIRMED.id }
    if homer.nil?  
      homer = User.create!( homer_attr )
    else
      homer.update_attributes(homer_attr)
    end

    u = User.find_by_email(@dummy_email)
    count = 0
    
    puts "Add compliments from Homer to Dummy"
    # Compliments from Dummy to coworker
    r = Relation.find_by_name('Coworker').id
    t = ComplimentType.COWORKER_TO_COWORKER
    tp = ComplimentType.PERSONAL_TO_PERSONAL
    501.times do |index|
      count += 1
      s = 24280
      c = @comments[4]
      Compliment.create!( :sender_email => homer.email, 
                          :receiver_email => u.email, :skill_id => s, 
                          :comment => c, :relation_id => t.id)
    end

    301.times do |index|
      count += 1
      s = 21788
      c = @comments[8]
      Compliment.create!( :sender_email => homer.email, 
                          :receiver_email => u.email, :skill_id => s, 
                          :comment => c, :relation_id => t.id)
    end

    101.times do |index|
      count += 1
      s = 22533
      c = @comments[0]
      Compliment.create!( :sender_email => homer.email, 
                          :receiver_email => u.email, :skill_id => s, 
                          :comment => c, :relation_id => tp.id)
    end

    301.times do |index|
      count += 1
      s = 20488
      c = @comments[1]
      Compliment.create!( :sender_email => homer.email, 
                          :receiver_email => u.email, :skill_id => s, 
                          :comment => c, :relation_id => t.id)
    end
    
    puts "#{cmd} Complete - #{count} Compliments Created"
  end
  
end

namespace :reward do
  @dummy_email = "dummy@example.org"

  desc "Add some rewards for the dummy user at various visibilities"
  task :add do |cmd, args|
    Rake::Task[:environment].invoke
    u = User.find_by_email(@dummy_email)
    
    u.rewards << Reward.GIFT_CARD_25
    u.rewards << Reward.GIFT_CARD_75
    u.save
  end
end

namespace :accomplishment do
  @dummy_email = "dummy@example.org"

  desc "Add some accomplishments for the dummy user at various visibilities"
  task :add do |cmd, args|
    Rake::Task[:environment].invoke
    u = User.find_by_email(@dummy_email)
    
    u.accomplishments << Accomplishment.TROPHY
    u.accomplishments << Accomplishment.LEVEL_1_COMPLIMENTER
    u.accomplishments << Accomplishment.LEVEL_2_COMPLIMENTER
    u.save
  end
end