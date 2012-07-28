class AddManagerAndEmploymentTypeToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :manager, :string
    add_column :experiences, :employment_type_id, :integer
  end
end
