class ChangeSwarsZipDlLogs < ActiveRecord::Migration[6.0]
  def up
    change_column_null :swars_zip_dl_logs, :swars_user_id, true
  end
end
