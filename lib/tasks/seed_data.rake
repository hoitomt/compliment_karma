namespace :compliment do
  @dummy_email = "dummy@example.org"
  @skills = ["Marketing", "Accounting", "Ruby on Rails", 
             "C# Developer", "Java Developer", "Financial Management",
             "Business Intelligence", "Systems Analysis", 
             "Quality Assurance", "Project Management"]
  @comments = ["You're awesome!", "I love your work", "Great Job on the Obama Case",
               "Sweet job", "Way to go", "Nice work on that project",
               "Good job", "Awesome", "You're a rockstar!", "You're great",
               "Chicago is a cool city"]
  
  desc "Add some compliments for the dummy user at various visibilities"
  task :add do |cmd, args|
    Rake::Task[:environment].invoke
    u = User.find_by_email(@dummy_email)
    count = 0
    
    puts "Add compliments from Dummy to Coworker"
    # Compliments from Dummy to coworker
    r = Relation.find_by_name('Coworker').id
    10.times do |index|
      count += 1
      re = "cw#{index}@#{u.domain}"
      s = @skills[index]
      c = @comments[index]
      Compliment.create!( :sender_email => u.email, 
                          :receiver_email => re, :skill => s, 
                          :comment => c, :relation_id => r)
    end
    
    puts "Add compliments from Coworker to Dummy"
    # Compliments from coworker to dummy
    r = Relation.find_by_name('Coworker').id
    10.times do |index|
      count += 1
      se = "cw#{index}@#{u.domain}"
      s = @skills[index]
      c = @comments[index]
      Compliment.create!( :sender_email => se, 
                          :receiver_email => u.email, :skill => s, 
                          :comment => c, :relation_id => r)
    end
    
    puts "Add compliments from Dummy to Client"
    # Compliments from dummy to client
    r = Relation.find_by_name('Client').id
    10.times do |index|
      count += 1
      re = "cw#{index}@#{index}client.com"
      s = @skills[index]
      c = @comments[index]
      Compliment.create!( :sender_email => u.email, 
                          :receiver_email => re, :skill => s, 
                          :comment => c, :relation_id => r)
    end
    
    puts "Add compliments from Client to Dummy"
    # Compliments from client to dummy - Assumes that client refers to dummy as client
    r = Relation.find_by_name('Client').id
    10.times do |index|
      count += 1
      se = "cw#{index}@#{index}client.com"
      s = @skills[index]
      c = @comments[index]
      Compliment.create!( :sender_email => se, 
                          :receiver_email => u.email, :skill => s, 
                          :comment => c, :relation_id => r)
    end
    
    puts "Add compliments from Dummy to Business Partner"
    # Compliments from dummy to business partners
    r = Relation.find_by_name('Business Partner').id
    10.times do |index|
      count += 1
      re = "bp#{index}@#{index}business-partner.com"
      s = @skills[index]
      c = @comments[index]
      Compliment.create!( :sender_email => u.email, 
                          :receiver_email => re, :skill => s, 
                          :comment => c, :relation_id => r)
    end
    
    puts "Add compliments from Business Partner to Dummy"
    # Compliments from business partner to dummy
    r = Relation.find_by_name('Business Partner').id
    10.times do |index|
      count += 1
      se = "bp#{index}@#{index}business-partner.com"
      s = @skills[index]
      c = @comments[index]
      Compliment.create!( :sender_email => se, 
                          :receiver_email => u.email, :skill => s, 
                          :comment => c, :relation_id => r)
    end
    
    puts "Add compliments from Dummy to Service Provider"
    # Compliments from dummy to service provider
    r = Relation.find_by_name('Service Provider').id
    10.times do |index|
      count += 1
      re = "sp#{index}@#{index}service-provider.com"
      s = @skills[index]
      c = @comments[index]
      Compliment.create!( :sender_email => u.email, 
                          :receiver_email => re, :skill => s, 
                          :comment => c, :relation_id => r)
    end
    
    puts "Add compliments from Service Provider to Dummy"
    # Compliments from service provider to dummy
    r = Relation.find_by_name('Business Partner').id
    10.times do |index|
      count += 1
      se = "sp#{index}@#{index}service-provider.com"
      s = @skills[index]
      c = @comments[index]
      Compliment.create!( :sender_email => se, 
                          :receiver_email => u.email, :skill => s, 
                          :comment => c, :relation_id => r)
    end
    
    puts "#{cmd} Complete - #{count} Compliments Created"
  end
  
  task :create_compliment, :sender_email, 
                           :receiver_email, 
                           :skill, 
                           :comment, 
                           :relation_id do |cmd, args|
    Rake::Task[:environment].invoke
    puts "Create Compliment"
    params = {:sender_email => args.sender_email, 
              :receiver_email => args.receiver_email,
              :skill => args.skill, 
              :comment => args.comment, 
              :relation_id => args.relation_id}
    Compliment.create!(params)
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