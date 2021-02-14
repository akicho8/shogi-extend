module Wkbk
  class AnswerLog < ApplicationRecord
    # with_options(readonly: true) do
    belongs_to :article
    belongs_to :answer_kind
    belongs_to :book
    belongs_to :user, class_name: "::User"
    # end

    scope :with_today,   -> t = Time.current { where(created_at: t.midnight...t.midnight.tomorrow) }
    scope :with_answer_kind, -> key { where(answer_kind: AnswerKind.fetch(key)) }
    scope :with_o,       -> { with_answer_kind(:correct) }
    scope :without_o,    -> { where.not(answer_kind: AnswerKind.fetch(:correct)) }

    # before_validation do
    #   self.answer_kind ||= AnswerKind.fetch(:mistake)
    # end

    before_validation do
      self.spent_sec ||= 0
    end
  end
end
