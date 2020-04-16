module Acns2
  class Room < ApplicationRecord
    has_many :messages, dependent: :destroy
    has_many :memberships, dependent: :destroy

    before_validation do
      self.begin_at ||= Time.current
      if final_key
        self.end_at ||= Time.current
      end
    end

    with_options presence: true do
      validates :begin_at
    end

    after_create_commit do
      Acns2::LobbyBroadcastJob.perform_later(self)
    end

    def simple_quest_infos
      QuestInfo.collect { |e| { base_sfen: e[:base_sfen], seq_answers: e[:seq_answers] } }
    end

    def final_info
      FinalInfo.fetch_if(final_key)
    end
  end
end
