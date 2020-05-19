module Actb
  class Folder < ApplicationRecord
    belongs_to :user

    has_many :questions, dependent: :destroy

    def name
      "#{user.name}の#{self.class.model_name.human}"
    end
  end
end
