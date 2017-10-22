class CreateBattle < ActiveRecord::Migration[5.1]
  def change
    create_table :battles do |t|
      t.references :game
    end

    create_table :battle_users do |t|
      t.references :battle
      t.string :user_name
      t.boolean :in
    end
  end
end
