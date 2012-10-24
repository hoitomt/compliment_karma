class CreateRecognitions < ActiveRecord::Migration
  def change
    create_table :recognitions do |t|
      t.integer :recognition_type_id
      t.integer :recognition_id
      t.string :public_url
      t.string :url_token

      t.timestamps
    end
  end
end
