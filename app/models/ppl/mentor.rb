# -*- coding: utf-8 -*-

module Ppl
  class Mentor < ApplicationRecord
    class << self
      def [](name)
        find_by(name: name)
      end

      def fetch(name)
        find_by!(name: name)
      end
    end

    has_many :users, dependent: :destroy   # 弟子たち

    # 大所帯ほど前にくる
    scope :link_order, -> { order(users_count: :desc) }

    # 連盟が記載した名前がめちゃくちゃなため
    normalizes :name, with: -> e { NameNormalizer.normalize(e) }

    with_options presence: true do
      validates :name
    end

    with_options allow_blank: true do
      validates :name, uniqueness: true
    end
  end
end
