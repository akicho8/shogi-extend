class ActsAsTaggleOnRenameTagNameBig4 < ActiveRecord::Migration[5.1]
  def up
    if record = ActsAsTaggableOn::Tag.find_by(name: "ビッグ４")
      record.update!(name: "ビッグ4")
    end
  end
end
