module TagMethods
  extend ActiveSupport::Concern

  # FIXME: これはプレイヤー情報を出す上で重要なタグになるので除外してはいけない、ことに気づいたのでいったん全部コメントにしておく
  mattr_accessor(:reject_tag_keys) {
    {
      :note => [
        # "対振り飛車", "対抗形", "相居玉", "大駒コンプリート", "大駒全ブッチ", "相居飛車",
      ],
      :technique => [
        # "金底の歩",
        # "パンツを脱ぐ",
        # "腹銀",
        # "垂れ歩",
        # # "遠見の角",
        # "割り打ちの銀",
        # "桂頭の銀",
        # # "ロケット",
        # "ふんどしの桂",
        # "継ぎ桂",
      ],
    }
  }

  included do
    acts_as_ordered_taggable_on :defense_tags
    acts_as_ordered_taggable_on :attack_tags
    acts_as_ordered_taggable_on :technique_tags
    acts_as_ordered_taggable_on :note_tags
  end

  # includes(taggings: tag) としたときは taggings.loaded? になるので一覧ではかなり速くなる
  def tag_names_for(key)
    @tag_names_for ||= {}
    @tag_names_for[key] ||= yield_self do
      context = "#{key}_tags"
      if taggings.loaded?
        taggings.find_all { |e| e.context == context }.collect { |e| e.tag.name }
      else
        send(context).pluck(:name)
      end
    end
  end

  def all_tag_names
    [:defense, :attack, :technique, :note].flat_map do |e|
      tag_names_for(e)
    end
  end
end
