class AddListNameToComplimentTypes < ActiveRecord::Migration
  def change
    add_column :compliment_types, :list_name, :string
  end
end
