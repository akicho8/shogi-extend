class FixAuthInfos2 < ActiveRecord::Migration[6.0]
  def change
    change_table :auth_infos do |t|
      t.remove :meta_info
      t.rename :meta_info2, :meta_info
    end
  end
end
