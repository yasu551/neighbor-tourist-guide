class Drop < ActiveRecord::Migration[7.1]
  def change
    drop_table :places do |t|
      t.string "uuid"
      t.string "name"
      t.string "description"
      t.float "latitude"
      t.float "longitude"
      t.string "ai_description"
      t.timestamps
    end
  end
end
