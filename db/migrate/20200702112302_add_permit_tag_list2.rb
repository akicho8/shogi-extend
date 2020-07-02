class AddPermitTagList2 < ActiveRecord::Migration[6.0]
  def up
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
