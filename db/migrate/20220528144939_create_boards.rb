class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :token
      t.integer :status, default: 0
      t.integer :first_player_id
      t.text :deck, default: [], array: true

      t.timestamps
    end
  end
end
