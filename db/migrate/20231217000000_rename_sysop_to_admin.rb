class RenameSysopToAdmin < ActiveRecord::Migration[5.1]
  def up
    if user = User.find_by(key: "admin")
      user.key = "admin"
      user.save!
    end
  end
end
