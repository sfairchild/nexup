class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name
      t.references :angle
      t.integer :max_players
    end
  end
end
