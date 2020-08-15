module Actb
  class Emotion < ApplicationRecord
    belongs_to :user, class_name: "::User"
    belongs_to :category, class_name: "Actb::EmotionCategory"

    before_validation on: :create do
      if Rails.env.test?
        self.name    ||= "(name)"
        self.message ||= "(message)"
        self.voice     ||= "(voice)"
      end

      self.name    ||= ""
      self.message ||= ""
      self.voice     ||= ""
    end

    with_options presence: true do
      validates :name
    end

    # with_options allow_blank: true, uniqueness: { scope: [:user_id, :category_id] } do
    #   validates :name
    #   # validates :message
    #   # validates :voice
    # end

    def category_key
      if category
        category.key
      end
    end

    def category_key=(key)
      self.category = EmotionCategory.fetch_if(key)
    end

    # jsから来たパラメーターでまとめて更新する
    #
    #   params = {
    #     "title"            => "(title)",
    #     "init_sfen"        => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
    #     "moves_answers"    => [{"moves_str"=>"4c5b"}],
    #     "time_limit_clock" => "1999-12-31T15:03:00.000Z",
    #   }
    #   question = user.actb_questions.build
    #   question.update_from_js(params)
    #   question.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]
    #
    def update_from_js(params)
      params = params.deep_symbolize_keys
      attrs = params.slice(*[
          :name,
          :message,
          :voice,
          :category_key,
        ])
      assign_attributes(attrs)
      save!
    end
  end
end
