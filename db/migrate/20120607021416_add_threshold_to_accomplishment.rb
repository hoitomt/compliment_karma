class AddThresholdToAccomplishment < ActiveRecord::Migration
  def change
    add_column :accomplishments, :threshold, :integer
  end
end
