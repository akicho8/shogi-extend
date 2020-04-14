module Tsume
  class Room < ApplicationRecord
    has_many :messages, dependent: :destroy
  end
end
