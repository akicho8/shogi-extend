class Fix5 < ActiveRecord::Migration[6.0]
  def change
    # ActiveRecord::Base.logger = nil
    # ActsAsTaggableOn::Tag.find_by(name: "居玉")&.taggings&.where(context: "note_tags")&.in_batches.update_all("context = 'defense_tags'")
    # ActsAsTaggableOn::Tag.find_by(name: "立石流")&.update!(name: "立石流四間飛車")
    # ActsAsTaggableOn::Tag.find_by(name: "５七金戦法")&.update!(name: "▲５七金戦法")
    {
      "５七金戦法"     => "▲５七金戦法",
      "３七銀戦法"     => "▲３七銀戦法",
      "４五歩早仕掛け" => "▲４五歩早仕掛け",
      "４六銀右急戦"   => "▲４六銀右急戦",
      "４六銀左急戦"   => "▲４六銀左急戦",
      "５五龍中飛車"   => "▲５五龍中飛車",
      "７二飛亜急戦"   => "▲７二飛亜急戦",
      "８五飛車戦法"   => "▲８五飛車戦法",
      "都成流"         => "都成流△３一金",
    }.each do |k, v|
      ActsAsTaggableOn::Tag.find_by(name: k)&.update!(name: v)
    end
  end
end
