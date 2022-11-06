class DeleteRobot < ActiveRecord::Migration[6.0]
  def up
    ForeignKey.disabled do
      tp User
      User.robot_only.each do |e|
        if e.email != "shogi.extend+bot@gmail.com"
          e.destroy!
        end
      end
      tp User
    end

    change_table :users do |t|
      t.remove :cpu_brain_key rescue nil
    end
  end
end
