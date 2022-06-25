class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.belongs_to :board
      t.integer :number_of_cards
      t.integer :round_number
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
