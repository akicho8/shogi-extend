module TagMethods
  extend ActiveSupport::Concern

  mattr_accessor(:reject_tag_keys) {
    {
      :note => ["対振り", "対抗型", "相居玉", "大駒コンプリート", "大駒全消失", "相居飛車"],
      :technique => [
        "金底の歩",
        "パンツを脱ぐ",
        "腹銀",
        "垂れ歩",
        # "遠見の角",
        "割り打ちの銀",
        "桂頭の銀",
        # "ロケット",
        "ふんどしの桂",
        "継ぎ桂",
      ],
    }.transform_values { |e| e.collect(&:to_sym) }
  }

  included do
    acts_as_ordered_taggable_on :defense_tags
    acts_as_ordered_taggable_on :attack_tags
    acts_as_ordered_taggable_on :technique_tags
    acts_as_ordered_taggable_on :note_tags
    acts_as_ordered_taggable_on :other_tags
  end

  # includes(taggings: tag) としたときは taggings.loaded? になるので一覧ではかなり速くなる
  def tag_names_for(key)
    @tag_names_for ||= {}
    @tag_names_for[key] ||= -> {
      context = "#{key}_tags"
      if taggings.loaded?
        taggings.find_all { |e| e.context == context }.collect { |e| e.tag.name }
      else
        send("#{key}_tags").pluck(:name)
      end
    }.call
  end

  def all_tag_names
    [:defense, :attack, :technique, :note, :other].flat_map do |e|
      tag_names_for(e)
    end
  end
end
