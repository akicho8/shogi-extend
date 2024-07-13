class CreateGoogleApiExpirationTracker < ActiveRecord::Migration[6.0]
  def change
    # drop_table :google_sheet_expiration_trackers, if_exists: true
    # drop_table :google_api_expiration_trackers, if_exists: true
    create_table :google_api_expiration_trackers, force: true do |t|
      t.string :spreadsheet_id, null: false
      t.timestamps
    end
  end
end
