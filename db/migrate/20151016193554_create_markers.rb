class CreateMarkers < ActiveRecord::Migration
  def change
    create_table :markers do |field|
      field.float :lat
      field.float :lng
      field.date :date
      field.time :time
      field.string :ticket_link
      field.string :artist_name
      field.string :event_title
      field.integer :map_id

      field.timestamps
    end
  end
end
