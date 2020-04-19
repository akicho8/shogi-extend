module Acns2
  class Question < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # 作者

    with_options dependent: :destroy do
      has_many :moves_answers  # 手順一致を正解とする答え集
      has_many :endpos_answers # 最後の局面を正解とする答え集
    end

    with_options allow_destroy: true do
      accepts_nested_attributes_for :moves_answers
      accepts_nested_attributes_for :endpos_answers
    end

    before_validation do
      [
        :title,
        :description,
        :hint_description,
        :source_desc,
        :other_twitter_account,
      ].each do |key|
        public_send("#{key}=", public_send(key).presence)
      end

      self.o_count ||= 0
      self.x_count ||= 0
    end

    with_options presence: true do
      validates :init_sfen
    end

    with_options allow_blank: true do
      validates :init_sfen, uniqueness: { case_sensitive: true }
    end
  end
end
