module Actb
  class Emotion < ApplicationRecord
    belongs_to :user, class_name: "::User"
    belongs_to :category, class_name: "Actb::EmotionCategory"

    before_validation on: :create do
      if Rails.env.test?
        self.name    ||= "(name)"
        self.message ||= "(message)"
        self.say     ||= "(say)"
      end

      self.name    ||= ""
      self.message ||= ""
      self.say     ||= ""
    end

    with_options presence: true do
      validates :name
    end

    with_options allow_blank: true, uniqueness: { scope: [:user_id, :category_id] } do
      validates :name
      validates :message
      validates :say
    end
  end
end
