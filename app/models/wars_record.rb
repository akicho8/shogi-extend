# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (wars_records as WarsRecord)
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
# | converted_ki2 | 変換後KI2          | text     |             |      |       |
# | converted_kif | 変換後KIF          | text     |             |      |       |
# | converted_csa | 変換後CSA          | text     |             |      |       |
# | turn_max      | 手数               | integer  |             |      |       |
# | kifu_header   | 棋譜ヘッダー       | text     |             |      |       |
# | created_at    | 作成日時           | datetime | NOT NULL    |      |       |
# | updated_at    | 更新日時           | datetime | NOT NULL    |      |       |
# |---------------+--------------------+----------+-------------+------+-------|

class WarsRecord < ApplicationRecord
  has_one :wars_ship_black, -> { where(position: 0) }, class_name: "WarsShip"
  has_one :wars_ship_white, -> { where(position: 1) }, class_name: "WarsShip"

  has_one :wars_ship_win,  -> { where(win_flag: true) }, class_name: "WarsShip"
  has_one :wars_ship_lose, -> { where(win_flag: false) }, class_name: "WarsShip"

  has_many :wars_ships, dependent: :destroy, inverse_of: :wars_record do
    def black
      first
    end

    def white
      second
    end
  end

  has_many :wars_users, through: :wars_ships do
    def black
      first
    end

    def white
      second
    end
  end

  belongs_to :win_wars_user, class_name: "WarsUser", optional: true

  before_validation do
    self.unique_key ||= SecureRandom.hex

    # "" から ten_min への変換
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
    validates :reason_key
  end

  with_options allow_blank: true do
    validates :battle_key, uniqueness: true
  end

  def to_param
    battle_key
  end

  def game_type_info
    GameTypeInfo.fetch(game_type_key)
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
            if wars_ships.second # 最初のときは、まだ保存されていないレコード
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
      n_part = -> e { "#{e.wars_user.user_key} #{e.wars_rank.name}" }

      out = ""
      out << "N+#{n_part[wars_ships.black]}\n"
      out << "N-#{n_part[wars_ships.white]}\n"
      out << csa_hands + "\n"
      out << "%#{reason_info.csa_key}\n"
      out
    end
  end

  concerning :HelperMethods do
    def aite_user_ship(wars_user)
      wars_ships.find {|e| e.wars_user != wars_user } # FIXME: wars_ships 下にメソッドとする
    end
  end

  concerning :ImportMethods do
    class_methods do
      def import_all(**params)
        GameTypeInfo.each do |e|
          import_one(params.merge(gtype: e.swars_key))
        end
      end

      def import_one(**params)
        wars_agent = WarsAgent.new
        list = wars_agent.battle_list_get(params)
        list.each do |history|
          unless WarsRecord.where(battle_key: history[:battle_key]).exists?
            info = wars_agent.battle_page_get(history[:battle_key])

            # 対局中だった場合
            unless info[:battle_done]
              next
            end

            # 引き分けを考慮すると急激に煩雑になるため取り込まない
            unless info[:kekka_key].match?(/(SENTE|GOTE)_WIN/)
              next
            end

            wars_users = history[:wars_user_infos].collect do |e|
              wars_user = WarsUser.find_or_initialize_by(user_key: e[:user_key])
              wars_rank = WarsRank.find_by!(unique_key: e[:wars_rank])
              wars_user.update!(wars_rank: wars_rank) # 常にランクを更新する
              wars_user
            end

            wars_record = WarsRecord.new
            wars_record.attributes = {
              battle_key: history[:battle_key],
              game_type_key: info.dig(:gamedata, :gtype),
              csa_hands: info[:csa_hands],
            }

            if md = info[:kekka_key].match(/(?<location>SENTE|GOTE)_WIN_(?<reason_key>\w+)/)
              katta_hou = md[:location] == "SENTE" ? 0 : 1
              wars_record.reason_key = md[:reason_key]
            else
              katta_hou = nil
              wars_record.reason_key = info[:kekka_key]
            end

            history[:wars_user_infos].each.with_index do |e, i|
              wars_user = WarsUser.find_by!(user_key: e[:user_key])
              wars_rank = WarsRank.find_by!(unique_key: e[:wars_rank])
              wars_record.wars_ships.build(wars_user:  wars_user, wars_rank: wars_rank, win_flag: i == katta_hou)
            end

            if katta_hou
              wars_record.win_wars_user = wars_record.wars_ships[katta_hou].wars_user
            end

            wars_record.save!
          end
        end
      end
    end

    def reason_info
      ReasonInfo[reason_key]
    end

    def winner_desuka?(wars_user)
      if win_wars_user
        win_wars_user == wars_user
      end
    end

    def lose_desuka?(wars_user)
      if win_wars_user
        win_wars_user != wars_user
      end
    end

    def kekka_emoji(wars_user)
      case
      when winner_desuka?(wars_user)
        "&#128522;"
      when lose_desuka?(wars_user)
        # "&#128552;"
        ""
      else
        # "引き分け"
        ""
      end
    end
  end
end
