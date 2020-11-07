class DeleteRobot < ActiveRecord::Migration[6.0]
  def up
    DbCop.foreign_key_checks_disable do
      tp User
      User.robot_only.each do |e|
        if e.email != "shogi.extend+bot@gmail.com"
          e.destroy!
        end
      end
      tp User
    end

    change_table :users do |t|
      t.remove :cpu_brain_key
    end
  end
end
