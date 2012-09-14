class SeedActionItemType < ActiveRecord::Migration
  def up
  	ActionItemType.create(:name => 'Authorize Compliment')
  end

  def down
  end
end
