# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Battle (share_board_battles as ShareBoard::Battle)
#
# |-----------------+--------------+-------------+-------------+----------------+-------|
# | name            | desc         | type        | opts        | refs           | index |
# |-----------------+--------------+-------------+-------------+----------------+-------|
# | id              | ID           | integer(8)  | NOT NULL PK |                |       |
# | room_id         | Room         | integer(8)  | NOT NULL    |                | B     |
# | key             | キー         | string(255) | NOT NULL    |                | A!    |
# | title           | タイトル     | string(255) | NOT NULL    |                |       |
# | sfen            | Sfen         | text(65535) | NOT NULL    |                |       |
# | turn            | Turn         | integer(4)  | NOT NULL    |                | C     |
# | win_location_id | Win location | integer(8)  | NOT NULL    | => Location#id | D     |
# | position        | 順序         | integer(4)  |             |                | E     |
# | created_at      | 作成日時     | datetime    | NOT NULL    |                |       |
# | updated_at      | 更新日時     | datetime    | NOT NULL    |                |       |
# |-----------------+--------------+-------------+-------------+----------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# 【警告:リレーション欠如】Locationモデルで has_many :share_board/battles されていません
# --------------------------------------------------------------------------------

module ShareBoard
  class Battle < ApplicationRecord
    belongs_to :room, touch: true, counter_cache: true
    acts_as_list top_of_list: 0, scope: :room

    custom_belongs_to :win_location, class_name: "Location", ar_model: Location, st_model: LocationInfo, default: :black

    has_many :memberships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle do
      def location_of(location_key)
        where(location: Location.fetch(location_key))
      end

      LocationInfo.each do |e|
        define_method(e.key) do
          where(location: Location.fetch(e.key))
        end
      end
    end

    if false
      LocationInfo.each do |e|
        define_method(e.key) do
          memberships.where(location: Location.fetch(e.key))
        end
      end
    else
      LocationInfo.each do |e|
        has_many e.key, -> { where(location: Location.fetch(e.key)).order(:position) }, dependent: :destroy, inverse_of: :battle, class_name: "ShareBoard::Membership"
      end
    end

    has_many :users, through: :memberships

    scope :latest_order, -> { order(position: :desc) }

    before_validation on: :create do
      self.key ||= SecureRandom.hex
      self.sfen ||= "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b"
      self.turn ||= Bioshogi::Parser.parse(sfen).container.turn_info.turn_offset
      self.title ||= ""
    end

    with_options presence: true do
      validates :key
      validates :sfen
      validates :turn
    end

    after_create do
      room.reload.roomships.each(&:rank_update) # Membership.create! 経由で roomship が更新されているため reload が必要
    end

    def to_share_board_url
      UrlProxy.full_url_for({
          path: "/share-board",
          query: {
            :xbody => SafeSfen.encode(sfen),
            :title => title,
            :black => black.collect { |e| e.user.name }.join(","),
            :white => white.collect { |e| e.user.name }.join(","),
            :turn  => turn,
          }.compact,
        })
    end
  end
end
