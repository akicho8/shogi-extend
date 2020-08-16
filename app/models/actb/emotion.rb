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

    before_validation do
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

    with_options allow_blank: true, uniqueness: { scope: [:user_id, :folder_id, :message, :voice], message: "とか同じのがすでにあります" } do
      validates :name
    end

    def folder_key
      if folder
        folder.key
      end
    end

    def folder_key=(key)
      self.folder = EmotionFolder.fetch_if(key)
    end

    def update_from_js(params)
      update!(params.slice(:id, :name, :message, :voice, :folder_key))
    end
  end
end
