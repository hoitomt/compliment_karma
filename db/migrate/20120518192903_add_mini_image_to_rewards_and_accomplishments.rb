class AddMiniImageToRewardsAndAccomplishments < ActiveRecord::Migration
  def change
    add_column :rewards, :image_mini, :string
    add_column :accomplishments, :image_mini, :string
    rename_column :rewards, :image, :image_thumb
    rename_column :accomplishments, :image, :image_thumb
  end
end
