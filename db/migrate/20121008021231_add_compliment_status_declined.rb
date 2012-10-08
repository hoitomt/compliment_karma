class AddComplimentStatusDeclined < ActiveRecord::Migration
  def change
    ComplimentStatus.create(:name => 'Declined')
  end
end
