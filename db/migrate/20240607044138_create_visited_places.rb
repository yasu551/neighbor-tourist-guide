class CreateVisitedPlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :visited_places do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :place, null: false, foreign_key: true

      t.timestamps
    end

    add_index :visited_places, %i[user_id place_id], unique: true
  end
end
