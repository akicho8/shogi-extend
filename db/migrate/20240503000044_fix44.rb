class Fix44 < ActiveRecord::Migration[6.0]
  def up
    if tag = ActsAsTaggableOn::Tag.find_by(name: "大駒全消失")
      tag.update!(name: "大駒全ブッチ")
    end
  end
end
