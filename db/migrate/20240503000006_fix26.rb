class Fix26 < ActiveRecord::Migration[6.0]
  def up
    # ["十段", "九段", "八段", "七段", "六段"].each do |grade_key|
    #   say_with_time "#{grade_key}" do
    #     Swars::Grade[grade_key].memberships.where(ai_drop_total: nil).find_each { |e| e.ai_columns_set; e.save! }
    #   end
    # end
    # Rails.application.credentials[:expert_import_user_keys].each do |user_key|
    #   say_with_time "#{user_key}" do
    #     if user = Swars::User.find_by(key: user_key)
    #       user.memberships.where(ai_drop_total: nil).find_each { |e| e.ai_columns_set; e.save! }
    #     end
    #   end
    # end
  end
end
