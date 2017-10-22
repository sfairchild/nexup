class CreateAngles < ActiveRecord::Migration[5.1]
  def change
    create_table :angles do |t|
      t.string :name
      t.integer :pivot
      t.decimal :zoom_x, default: 0.0
      t.decimal :zoom_y, default: 0.0
      t.decimal :zoom_w, default: 1.0
      t.decimal :zoom_h, default: 1.0
    end
  end
end
