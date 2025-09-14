module TagMethods
  extend ActiveSupport::Concern

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

  # これは使うな
  def all_tag_names
    [:defense, :attack, :technique, :note].flat_map do |e|
      tag_names_for(e)
    end
  end

  def all_tag_names_set
    @all_tag_names_set ||= yield_self do
      if taggings.loaded?
        names = taggings.collect { |e| e.tag.name }
      else
        names = taggings.includes(:tag).pluck(:name)
      end
      names.collect(&:to_sym).to_set
    end
  end

  # for debug
  def tag_info
    {
      :defense_tag_list   => defense_tag_list,
      :attack_tag_list    => attack_tag_list,
      :technique_tag_list => technique_tag_list,
      :note_tag_list      => note_tag_list,
    }
  end

  # def x_tags_set
  #   if taggings.loaded?
  #     taggings.collect { |e| e.tag.name.to_sym }.to_set
  #   end
  # end
end
