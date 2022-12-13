class RenameTuujouToNora < ActiveRecord::Migration[5.1]
  def up
    Swars::Xmode.find_by(key: "通常")&.update!(key: "野良")
    tp Swars::Xmode
  end
end
