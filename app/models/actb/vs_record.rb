module Actb
  class VsRecord < ApplicationRecord
    belongs_to :battle, inverse_of: :memberships

    before_validation do
      self.sfen_body = sfen_body.presence || "position startpos"
    end

    with_options presence: true do
      validates :sfen_body
    end
  end
end
