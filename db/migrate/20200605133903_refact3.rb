class Refact3 < ActiveRecord::Migration[6.0]
  def change
    remove_column :profiles, :end_greeting_message
    remove_column :profiles, :begin_greeting_message

    change_table :profiles do |t|
      t.string :introduction, limit: 512
    end

    Profile.reset_column_information
    Profile.find_each do |e|
      if e.respond_to?(:introduction)
        e.introduction ||= ""
        e.save!
      end
    end

    change_column :profiles, :introduction, :string, null: false
  end
end
