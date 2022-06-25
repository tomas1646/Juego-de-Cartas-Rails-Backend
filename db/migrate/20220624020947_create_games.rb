class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.belongs_to :round
      t.integer :game_number
      t.integer :winner_id
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
