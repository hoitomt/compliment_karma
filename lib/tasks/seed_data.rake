namespace :ck do
  @dummy_email = "dummy@example.org"
  @homer_email = "homerj@springfield.net"
  @comments = ["You're awesome!", "I love your work", "Great Job on the Obama Case",
               "Sweet job", "Way to go", "Nice work on that project",
               "Good job", "Awesome", "You're a rockstar!", "You're great",
               "Chicago is a cool city"]
               
  desc "Seed the Database"
  task :seed_database => [:add_skills, :add_compliments, :add_rewards, :add_compliments] do
    puts "Database has been seeded"
  end

  desc "Add some compliments for the dummy user at various visibilities"
  task :add_compliments do |cmd, args|
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
    t = ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
    tp = ComplimentType.PERSONAL_TO_PERSONAL
    501.times do |index|
      count += 1
      s = Skill.find(index + 1)
      c = @comments[4]
      Compliment.create!( :sender_email => homer.email, 
                          :receiver_email => u.email, :skill_id => s.id, 
                          :comment => c, :compliment_type_id => t.id,
                          :suppress_fulfillment => true)
    end

    puts "Add compliments from Homer to Dummy2"
    301.times do |index|
      count += 1
      s = Skill.find(index + 501)
      c = @comments[8]
      Compliment.create!( :sender_email => homer.email, 
                          :receiver_email => u.email, :skill_id => s.id, 
                          :comment => c, :compliment_type_id => t.id,
                          :suppress_fulfillment => true)
    end

    puts "Add compliments from Homer to Dummy3"
    101.times do |index|
      count += 1
      s = Skill.find(index + 802)
      c = @comments[0]
      Compliment.create!( :sender_email => homer.email, 
                          :receiver_email => u.email, :skill_id => s.id, 
                          :comment => c, :compliment_type_id => tp.id,
                          :suppress_fulfillment => true)
    end

    puts "Add compliments from Homer to Dummy4"
    301.times do |index|
      count += 1
      s = Skill.find(index + 903)
      c = @comments[1]
      Compliment.create!( :sender_email => homer.email, 
                          :receiver_email => u.email, :skill_id => s.id, 
                          :comment => c, :compliment_type_id => t.id,
                          :suppress_fulfillment => true)
    end
    
    puts "#{cmd} Complete - #{count} Compliments Created"
  end

  desc "Populate the database with skills"
  task :add_skills do |cmd, args|
    Rake::Task[:environment].invoke
    SkillsLoader.parse_list
  end

  desc "Add some rewards for the dummy user at various visibilities"
  task :add_rewards do |cmd, args|
    Rake::Task[:environment].invoke
    receiver = User.find_by_email(@dummy_email)
    presenter = User.find_by_email(@homer_email)
    Reward.create(:receiver_id => receiver.id, :presenter_id => presenter.id, :value => 25)
    Reward.create(:receiver_id => receiver.id, :presenter_id => presenter.id, :value => 75)
  end

  desc "Add some accomplishments for the dummy user at various visibilities"
  task :add_accomplishments do |cmd, args|
    Rake::Task[:environment].invoke
    u = User.find_by_email(@dummy_email)
    
    u.accomplishments << Accomplishment.TROPHY
    u.accomplishments << Accomplishment.LEVEL_1_COMPLIMENTER
    u.accomplishments << Accomplishment.LEVEL_2_COMPLIMENTER
    u.save
  end
end