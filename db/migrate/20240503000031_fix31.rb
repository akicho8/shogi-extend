class Fix31 < ActiveRecord::Migration[6.0]
  def up
    Swars::Membership.reset_column_information
    ["四段", "三段", "二段", "初段"].each do |grade_key|
      say_with_time "#{grade_key}" do
        Swars::Grade[grade_key].memberships.where(ai_drop_total: nil).find_each { |e| e.ai_columns_set; e.save(validate: false) }
      end
    end
  end
end
