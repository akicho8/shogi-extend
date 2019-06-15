module TaggingModel
  extend ActiveSupport::Concern

  included do
    acts_as_ordered_taggable_on :defense_tags
    acts_as_ordered_taggable_on :attack_tags
    acts_as_ordered_taggable_on :technique_tags
    acts_as_ordered_taggable_on :note_tags
  end

  # includes(taggings: tag) としたときは taggings.loaded? になるので一覧ではかなり速くなる
  def tag_names_for(key)
    context = "#{key}_tags"
    if taggings.loaded?
      taggings.find_all { |e| e.context == context }.collect { |e| e.tag.name }
    else
      send("#{key}_tags").pluck(:name)
    end
  end
end
