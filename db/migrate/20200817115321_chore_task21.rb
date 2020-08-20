class ChoreTask21 < ActiveRecord::Migration[6.0]
  def up
    User.reset_column_information
    User.find_each do |e|
      e.confirmed_at ||= Time.current
      e.save!
    end
  end
end
