class CreateRecognitionTypes < ActiveRecord::Migration
  def change
    create_table :recognition_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
