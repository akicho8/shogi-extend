module Wkbk
  class AnswerLog < ApplicationRecord
    # with_options(readonly: true) do
    belongs_to :article
    belongs_to :ox_mark
    belongs_to :book
    belongs_to :user, class_name: "::User"
    # end

    scope :with_today,   -> t = Time.current { where(created_at: t.midnight...t.midnight.tomorrow) }
    scope :with_ox_mark, -> key { where(ox_mark: OxMark.fetch(key)) }
    scope :with_o,       -> { with_ox_mark(:correct) }
    scope :without_o,    -> { where.not(ox_mark: OxMark.fetch(:correct)) }

    # before_validation do
    #   self.ox_mark ||= OxMark.fetch(:mistake)
    # end
  end
end
