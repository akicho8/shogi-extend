class BotEmailSet < ActiveRecord::Migration[6.0]
  def up
    if user = User.find_by(email: "bot@localhost")
      user.email = "shogi.extend+bot@gmail.com"
      user.save!
    end

    CpuBrainInfo.each do |e|
      if user = User.robot_only.find_by(key: e.key)
        user.email = "shogi.extend+cpu-#{e.key}@gmail.com"
        user.save!
      end
    end

    [
      "shogi.extend@gmail.com",
      "shogi.extend+bot@gmail.com",
      "pinpon.ikeda+kinakomochi@gmail.com",
      "shogi.extend+cpu-level1@gmail.com",
    ].each do |email|
      if user = User.find_by(email: email)
        user.permit_tag_list = "staff"
        user.save!
      end
    end
    [
      "pinpon.ikeda+splawarabimochi@gmail.com",
    ].each do |email|
      if user = User.find_by(email: email)
        user.permit_tag_list = ""
        user.save!
      end
    end
  end
end
