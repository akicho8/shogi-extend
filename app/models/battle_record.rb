# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (battle_records as BattleRecord)
#
# |---------------+--------------------+----------+-------------+------+-------|
# | カラム名      | 意味               | タイプ   | 属性        | 参照 | INDEX |
# |---------------+--------------------+----------+-------------+------+-------|
# | id            | ID                 | integer  | NOT NULL PK |      |       |
# | unique_key    | ユニークなハッシュ | string   | NOT NULL    |      |       |
# | battle_key    | Battle key         | string   | NOT NULL    |      |       |
# | battled_at    | Battled at         | datetime | NOT NULL    |      |       |
# | game_type_key | Game type key      | string   | NOT NULL    |      |       |
# | csa_hands     | Csa hands          | text     | NOT NULL    |      |       |
# | kifu_body     | 棋譜内容           | text     |             |      |       |
# | converted_ki2 | 変換後KI2          | text     |             |      |       |
# | converted_kif | 変換後KIF          | text     |             |      |       |
# | converted_csa | 変換後CSA          | text     |             |      |       |
# | turn_max      | 手数               | integer  |             |      |       |
# | kifu_header   | 棋譜ヘッダー       | text     |             |      |       |
# | created_at    | 作成日時           | datetime | NOT NULL    |      |       |
# | updated_at    | 更新日時           | datetime | NOT NULL    |      |       |
# |---------------+--------------------+----------+-------------+------+-------|

class BattleRecord < ApplicationRecord
  has_many :battle_ships, dependent: :destroy
  has_many :battle_users, through: :battle_ships

  # with_options(class_name: "Type010File", dependent: :destroy, inverse_of: :type010_article) do
  #   has_one :type010_file_a, -> { order(created_at: :desc).where(position: 0) }
  #   has_one :type010_file_b, -> { order(created_at: :desc).where(position: 1) }
  #   has_one :type010_file_c, -> { order(created_at: :desc).where(position: 2) }
  # end

  before_validation do
    self.unique_key ||= SecureRandom.hex

    if game_type_key
      self.game_type_key = GameTypeInfo.fetch(game_type_key).key
    end

    if battle_key
      self.battled_at = Time.zone.parse(battle_key.split("-").last)
    end
  end

  with_options presence: true do
    validates :unique_key
    validates :battle_key
    validates :battled_at
    validates :game_type_key
    validates :csa_hands
  end

  with_options allow_blank: true do
    validates :battle_key, uniqueness: true
  end

  def to_param
    battle_key
  end

  def game_type_info
    GameTypeInfo.fetch_if(game_type_key)
  end

  concerning :HenkanMethods do
    included do
      serialize :kifu_header

      before_validation do
        self.kifu_header ||= {}
        self.turn_max ||= 0
      end

      before_save do
        if changes[:csa_hands]
          if csa_hands
            if battle_ships.second # 最初のときは、まだ保存されていないレコード
              info = Bushido::Parser.parse(kifu_body)
              self.converted_ki2 = info.to_ki2
              self.converted_kif = info.to_kif
              self.converted_csa = info.to_csa
              self.turn_max = info.mediator.turn_max
              self.kifu_header = info.header
            end
          end
        end
      end
    end

    def kifu_body
      out = ""
      battle_ship = battle_ships.first
      out << "N+#{battle_ship.battle_user.user_key} #{battle_ship.battle_user_rank.name}\n"
      battle_ship = battle_ships.second
      out << "N-#{battle_ship.battle_user.user_key} #{battle_ship.battle_user_rank.name}\n"
      out << csa_hands + "\n"
      out
    end
  end

  concerning :HelperMethods do
    def aite_user_ship(battle_user)
      battle_ships.find {|e| e.battle_user != battle_user } # FIXME: battle_ships 下にメソッドとする
    end
  end
end
