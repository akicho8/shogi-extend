class Fix7 < ActiveRecord::Migration[6.0]
  def change
    {
      "音無しの構え" => "居飛穴音無しの構え",
    }.each do |k, v|
      ActsAsTaggableOn::Tag.find_by(name: k)&.update!(name: v)
    end
  end
end
