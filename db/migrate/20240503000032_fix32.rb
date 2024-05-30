class Fix32 < ActiveRecord::Migration[6.0]
  def up
    if tag = ActsAsTaggableOn::Tag.find_by(name: "対抗形")
      if tag.taggings.count.zero?
        tag.destroy!
      end
    end

    if tag = ActsAsTaggableOn::Tag.find_by(name: "対抗型")
      tag.update!(name: "対抗形")
    end

    p ActsAsTaggableOn::Tag.find_by(name: "対抗型")
    p ActsAsTaggableOn::Tag.find_by(name: "対抗形")
  end
end
