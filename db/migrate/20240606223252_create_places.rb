class CreatePlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :places do |t|
      t.string :uuid, null: false
      t.string :name, null: false
      t.string :description, null: false, default: ''
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :photo_url, null: false
      t.string :ai_description

      t.timestamps
    end
  end
end
