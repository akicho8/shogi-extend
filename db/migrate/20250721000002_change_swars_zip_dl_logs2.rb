class ChangeSwarsZipDlLogs2 < ActiveRecord::Migration[6.0]
  def up
    remove_column(:swars_zip_dl_logs, :swars_user_id, if_exists: true)
  end
end
