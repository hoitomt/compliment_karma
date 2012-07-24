class AddProfessionalIntroToUser < ActiveRecord::Migration
  def change
    add_column :users, :professional_intro, :text
    add_column :users, :social_intro, :text
  end
end
