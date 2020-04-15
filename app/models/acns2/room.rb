module Acns2
  class Room < ApplicationRecord
    has_many :messages, dependent: :destroy
    has_many :memberships, dependent: :destroy

    after_create_commit do
      Acns2::LobbyBroadcastJob.perform_later(self)
    end
  end
end
