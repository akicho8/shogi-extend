class Fix5 < ActiveRecord::Migration[5.1]
  def change
    if r = ActsAsTaggableOn::Tag.find_by(name: "菊水穴熊")
      r.name = "菊水矢倉"
      r.save!
    end
  end
end
