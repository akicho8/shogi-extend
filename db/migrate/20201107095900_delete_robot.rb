class DeleteRobot < ActiveRecord::Migration[6.0]
  def up
    DbCop.foreign_key_checks_disable do
      tp User
      User.robot_only.each do |e|
        if e.email != "shogi.extend+bot@gmail.com"
          e.destroy!
        end
      end

      User.find_each do |e|
        if e.email.to_s.include?("@localhost")
          e.email = ""
          e.save!(validate: false, touch: false)
        end
      end

      tp User
    end

    change_table :users do |t|
      t.remove :cpu_brain_key rescue nil
      t.remove :name_input_at rescue nil
      # t.remove_index :index_users_on_email

      t.remove_index :email
      t.index :email, unique: false
    end

    create_table :session_users, force: true do |t|
      t.belongs_to :user
      t.string :key, null: false, index: { unique: true }
      t.timestamps   null: false
    end
  end
end
