class BotEmailSet < ActiveRecord::Migration[6.0]
  def up
    User.bot.destroy
    User.bot

    if user = User.find_by(email: "bot@localhost")
      user.email = "shogi.extend+bot@gmail.com"
      user.save!
    end

    if user = User.find_by(email: "pinpon.ikeda+ureshinobomb@gmail.com")
      user.email = "pinpon.ikeda+kinakomochi@gmail.com"
      user.save!
    end

    CpuBrainInfo.each do |e|
      user = User.robot_only.find_by(key: e.key)
      user.email = "shogi.extend+cpu-#{e.key}@gmail.com"
      user.save!
    end
  end
end
