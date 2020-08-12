class ChoreTask14 < ActiveRecord::Migration[6.0]
  def up
    User.reset_column_information
    unless User.column_names.include?("name_input_at")
      change_table :users do |t|
        t.datetime :name_input_at
      end
    end
    User.reset_column_information
    User.find_each do |e|
      e.name_input_at = e.created_at

      if e.name.to_s.match?(/名無し|名なし|ななし|棋士\d+号/)
        e.name_input_at = nil
      end
      if e.name.size == 1
        e.name_input_at = nil
      end
      if e.email.to_s.split(/@/).first == e.name
        e.name_input_at = nil
      end
      e.save!
    end
  end
end
