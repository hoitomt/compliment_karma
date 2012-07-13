class AddCountryToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :country, :string
    add_column :users, :country, :string
  end
end
