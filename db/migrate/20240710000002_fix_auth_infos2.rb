class FixAuthInfos2 < ActiveRecord::Migration[6.0]
  def change
    change_table :auth_infos do |t|
      t.remove :meta_info rescue nil
      t.rename :meta_info2, :meta_info rescue nil
    end
  end
end
