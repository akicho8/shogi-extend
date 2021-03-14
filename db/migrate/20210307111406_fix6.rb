class Fix6 < ActiveRecord::Migration[6.0]
  def change
    {
      "超速" => "超速▲３七銀",
    }.each do |k, v|
      ActsAsTaggableOn::Tag.find_by(name: k)&.update!(name: v)
    end
  end
end
