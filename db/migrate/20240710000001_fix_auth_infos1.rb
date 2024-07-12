class FixAuthInfos1 < ActiveRecord::Migration[6.0]
  def change
    # change_table :auth_infos do |t|
    #   t.text :meta_info2, comment: "JSON形式での保存用"
    # end
    #
    # User.reset_column_information
    # AuthInfo.reset_column_information
    #
    # if true
    #   User.count                      # => 5
    #   count = AuthInfo.count
    #   success = 0
    #   error = 0
    #   AuthInfo.find_each do |record|
    #     src = record.meta_info_before_type_cast
    #     if src.kind_of?(String)
    #       record.meta_info2 = Psych.load(src).as_json
    #       record.save!(validate: false)
    #       record.reload
    #     end
    #     if record.meta_info.kind_of?(Hash)
    #       success += 1
    #     else
    #       error += 1
    #     end
    #     count -= 1
    #     p [count, success, error]
    #   end
    # end
  end
end
