class CreateTurns < ActiveRecord::Migration[7.0]
  def change
    create_table :turns do |t|
      t.belongs_to :game
      t.belongs_to :player

      t.string :card_played, default: ''
      t.integer :player_position

      t.timestamps
    end
  end
end
