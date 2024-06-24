class Fix46 < ActiveRecord::Migration[6.0]
  def up
    # if tag = ActsAsTaggableOn::Tag.find_by(name: "相振り飛車")
    #   tag.taggings.where(context: "attack_tags").destroy_all
    # end
  end
end
