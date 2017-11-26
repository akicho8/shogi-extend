# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (wars_records as WarsRecord)
#
# |------------------+--------------------+-------------+-------------+----------------+-------|
# | カラム名         | 意味               | タイプ      | 属性        | 参照           | INDEX |
# |------------------+--------------------+-------------+-------------+----------------+-------|
# | id               | ID                 | integer(8)  | NOT NULL PK |                |       |
# | unique_key       | ユニークなハッシュ | string(255) | NOT NULL    |                |       |
# | battle_key       | Battle key         | string(255) | NOT NULL    |                |       |
# | battled_at       | Battled at         | datetime    | NOT NULL    |                |       |
# | game_type_key    | Game type key      | string(255) | NOT NULL    |                |       |
# | csa_hands        | Csa hands          | text(65535) | NOT NULL    |                |       |
# | reason_key       | Reason key         | string(255) | NOT NULL    |                |       |
# | win_wars_user_id | Win wars user      | integer(8)  |             | => WarsUser#id | A     |
# | turn_max         | 手数               | integer(4)  |             |                |       |
# | kifu_header      | 棋譜ヘッダー       | text(65535) |             |                |       |
# | created_at       | 作成日時           | datetime    | NOT NULL    |                |       |
# | updated_at       | 更新日時           | datetime    | NOT NULL    |                |       |
# |------------------+--------------------+-------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】WarsUserモデルで has_many :wars_records されていません
#--------------------------------------------------------------------------------

class WarsRecord < ApplicationRecord
  has_one :wars_ship_black, -> { where(position: 0) }, class_name: "WarsShip"
  has_one :wars_ship_white, -> { where(position: 1) }, class_name: "WarsShip"

  has_one :wars_ship_win,  -> { where(win_flag: true) }, class_name: "WarsShip"
  has_one :wars_ship_lose, -> { where(win_flag: false) }, class_name: "WarsShip"

  has_many :wars_ships, -> { order(:position) }, dependent: :destroy, inverse_of: :wars_record do
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
      self.battled_at ||= Time.zone.parse(battle_key.split("-").last)
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
      has_many :converted_infos, as: :convertable, dependent: :destroy

      serialize :kifu_header
      serialize :csa_hands

      before_validation do
        self.kifu_header ||= {}
        self.turn_max ||= 0
      end

      before_save do
        if changes[:csa_hands]
          if csa_hands
            if wars_ships.second # 最初のときは、まだ保存されていないレコード
              info = Bushido::Parser.parse(kifu_body)
              converted_infos.destroy_all
              KifuFormatInfo.each do |e|
                converted_infos.build(converted_body: info.public_send("to_#{e.key}"), converted_format: e.key)
              end
              self.turn_max = info.mediator.turn_max
              self.kifu_header = info.header
            end
          end
        end
      end
    end

    def kifu_body
      out = []
      out << "N+#{wars_ships.black.name_with_rank}"
      out << "N-#{wars_ships.white.name_with_rank}"
      out << "$START_TIME:#{battled_at.to_s(:csa_ymdhms)}"
      out << "$EVENT:将棋ウォーズ(#{game_type_info.long_name})"
      out << "$TIME_LIMIT:#{game_type_info.csa_time_limit}"
      # out << "$OPENING:不明"
      out << "+"

      nokori = [game_type_info.real_mochi_jikan] * 2
      csa_hands.each.with_index { |(a, b), i|
        i = i.modulo(nokori.size)
        tsukatta = nokori[i] - b
        nokori[i] = b

        out << "#{a}"
        out << "T#{tsukatta}"
      }

      out << "%#{reason_info.csa_key}"
      out.join("\n") + "\n"
    end
  end

  concerning :HelperMethods do
    def aite_user_ship(wars_user)
      wars_ships.find {|e| e.wars_user != wars_user } # FIXME: wars_ships 下にメソッドとする
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
      if winner_desuka?(wars_user)
        # "&#x1f604;"
        # "&#x1F4AE;"             # たいへんよくできました
        "&#x1f601;"             # にっこり
      else
        # "&#128552;"
        "&#x274c;"              # 赤い×
      end
    end
  end

  concerning :ImportMethods do
    class_methods do
      def wars_agent
        @wars_agent ||= WarsAgent.new
      end

      def import_all(**params)
        GameTypeInfo.each do |e|
          import_one(params.merge(gtype: e.swars_key))
        end
      end

      def import_one(**params)
        list = wars_agent.battle_list_get(params)
        list.each do |history|
          import_by_battle_key(history[:battle_key])
        end
      end

      def import_by_battle_key(battle_key)
        # 登録済みなのでスキップ
        if WarsRecord.where(battle_key: battle_key).exists?
          return
        end

        info = wars_agent.battle_page_get(battle_key)

        # 対局中や引き分けのときは棋譜がないのでスキップ
        unless info[:battle_done]
          return
        end

        # # 引き分けを考慮すると急激に煩雑になるため取り込まない (そもそも引き分けには棋譜がない)
        # unless info[:src_reason_key].match?(/(SENTE|GOTE)_WIN/)
        #   next
        # end

        wars_users = info[:wars_user_infos].collect do |e|
          WarsUser.find_or_initialize_by(user_key: e[:user_key]).tap do |wars_user|
            wars_rank = WarsRank.find_by!(unique_key: e[:wars_rank])
            wars_user.update!(wars_rank: wars_rank) # 常にランクを更新する
          end
        end

        wars_record = WarsRecord.new
        wars_record.attributes = {
          battle_key: info[:battle_key],
          game_type_key: info.dig(:gamedata, :gtype),
          csa_hands: info[:csa_hands],
        }

        if md = info[:src_reason_key].match(/(?<location>SENTE|GOTE)_WIN_(?<reason_key>\w+)/)
          winner_index = md[:location] == "SENTE" ? 0 : 1
          wars_record.reason_key = md[:reason_key]
        else
          raise "must not happen"
          winner_index = nil
          wars_record.reason_key = info[:src_reason_key]
        end

        info[:wars_user_infos].each.with_index do |e, i|
          wars_user = WarsUser.find_by!(user_key: e[:user_key])
          wars_rank = WarsRank.find_by!(unique_key: e[:wars_rank])
          wars_record.wars_ships.build(wars_user:  wars_user, wars_rank: wars_rank, win_flag: i == winner_index)
        end

        # SQLをシンプルにするために勝者だけ、所有者的な意味で、WarsRecord 自体に入れとく
        # いらんかったらあとでとる
        if winner_index
          wars_record.win_wars_user = wars_record.wars_ships[winner_index].wars_user
        end

        wars_record.save!
      end
    end

    def reason_info
      ReasonInfo[reason_key]
    end
  end

  concerning :KaisekiMethoes do
    included do
    end

    class_methods do
    end

    def kaiseki_kekka_hash(location)
      kishin_count = 5

      location = Bushido::Location[location]
      list = csa_hands.find_all.with_index { |e, i| i.modulo(2) == location.code }
      v1 = list.collect { |a, b| b }

      v2 = v1.chunk_while { |a, b| (a - b) <= 2 }.to_a              # => [[136], [121], [101], [28], [18, 17, 16, 15, 14, 12], [7, 136], [121], [101], [28], [18, 17, 16, 15, 14, 12, 11]]
      v3 = v2.collect(&:size)                                      # => [1, 1, 1, 1, 6, 2, 1, 1, 1, 7]
      v4 = v3.group_by(&:itself).transform_values(&:size)          # => {1=>7, 6=>1, 2=>1, 7=>1}
      v5 = v4.count { |k, v| k > kishin_count }                              # => 2
      v6 = v5 >= 1

      {
        v1: v1,
        v2: v2,
        v3: v3,
        v4: v4,
        v5: v5,
        v6: v6,
      }
    end

    def kishin_tsukatta?(user_ship)
      if game_type_info.key == :ten_min || !Rails.env.production?
        kaiseki_kekka_hash(user_ship.position).values.last
      end
    end
  end
end
