class CreateRoundPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :round_players do |t|
      t.belongs_to :round
      t.belongs_to :player
      t.integer :bet_wins
      t.integer :current_wins, default: 0
      t.integer :bet_position
      t.text :cards, default: [], array: true

      t.timestamps
    end
  end
end
