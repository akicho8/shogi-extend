# -*- compile-command: "rails r 'Actb::EmotionFolder.setup; User.first.emotions_setup(reset: true);'" -*-

module Actb
  class Emotion < ApplicationRecord
    class << self
      def json_type13
        {
          only: [
            :id,
            :name,
            :message,
            :voice,
          ],
          methods: [
            :folder_key,
          ],
        }
      end
    end

    belongs_to :user, class_name: "::User"
    belongs_to :folder, class_name: "Actb::EmotionFolder"

    acts_as_list top_of_list: 0, scope: [:folder_id, :user_id]
    default_scope { order(:position) }

    before_validation on: :create do
      if Rails.env.test?
        self.name    ||= "(name)"
        self.message ||= "(message)"
        self.voice   ||= "(voice)"
      end

      self.name    ||= ""
      self.message ||= ""
      self.voice   ||= ""
    end

    with_options presence: true do
      validates :name
    end

    # with_options allow_blank: true, uniqueness: { scope: [:user_id, :folder_id] } do
    #   validates :name
    #   # validates :message
    #   # validates :voice
    # end

    def folder_key
      if folder
        folder.key
      end
    end

    def folder_key=(key)
      self.folder = EmotionFolder.fetch_if(key)
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
          :folder_key,
        ])
      assign_attributes(attrs)
      save!
    end
  end
end
