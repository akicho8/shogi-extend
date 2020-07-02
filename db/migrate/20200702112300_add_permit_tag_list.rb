class AddPermitTagList < ActiveRecord::Migration[6.0]
  def up
    [
      "shogi.extend@gmail.com",
      "shogi.extend+bot@gmail.com",
      "pinpon.ikeda+kinakomochi@gmail.com",
      "pinpon.ikeda+splawarabimochi@gmail.com",
      "shogi.extend+cpu-level1@gmail.com",
    ].each do |email|
      if user = User.find_by(email: email)
        user.permit_tag_list = "staff"
        user.save!
      end
    end
  end
end
