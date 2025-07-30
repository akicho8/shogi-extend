# frozen-string-literal: true

module Swars
  module Agent
    class PropsAdapter
      attr_accessor :props
      attr_accessor :options

      def initialize(react_props, options = {})
        @props = react_props.fetch("gameHash")
        @options = options
      end

      def to_h
        {
          "対局KEY"   => key,
          "対局日時"  => battled_at.strftime("%F %T"),
          "ルール"    => rule_info,
          "種類"      => xmode_info,
          "開始局面"  => imode_info,
          "手合割"    => preset_info,
          "結末"      => final_info,
          "両者名前"  => memberships.collect { |e| [e[:user_key], e[:grade_info].name].join(":") }.join(" vs "),
          "勝った側"  => winner_location,
          "対局後か?" => battle_done?,
          "対局中か?" => battle_now?,
          "正常終了?" => valid?,
          "棋譜有り?" => !!csa_seq,
          "棋譜手数"  => csa_seq ? csa_seq.length : "",
          "初期配置"  => starting_position,
        }
      end

      def to_battle_attributes
        {
          :key               => key.to_s,
          :rule_key          => rule_info.key,
          :final_key         => final_info.key,
          :csa_seq           => csa_seq, # FIXME: SFEN を渡す。時間は別にする
          :preset_key        => preset_info.key,
          :xmode_key         => xmode_info.key,
          :imode_key         => imode_info.key,
          :battled_at        => battled_at,
          :starting_position => starting_position,
        }
      end

      def to_battle_membership_attributes
        memberships.collect.with_index do |e, i|
          {
            :user         => User.find_by!(user_key: e[:user_key]),
            :grade_key    => e[:grade_info].key,
            :judge_key    => e[:judge_info].key,
            :location_key => LocationInfo.fetch(i).key,
          }
        end
      end

      # 対局KEY
      def key
        @key ||= options[:key] || BattleKey.create(props.fetch("name"))
      end

      # 対局日時
      # データには含まれていないため key から取り出す
      def battled_at
        @battled_at ||= key.to_time
      end

      # 10分・3分・10秒
      def rule_info
        @rule_info ||= RuleInfo.fetch(rule_key)
      end

      # 野良・友対・指導・謎BOT
      def xmode_info
        @xmode_info ||= yield_self do
          if info = XmodeMagicNumberInfo.lookup_by_magic_number(props.fetch("opponent_type"))
            info.xmode_info
          end
        end
      end

      # 開始モード
      def imode_info
        @imode_info ||= yield_self do
          if info = ImodeMagicNumberInfo.lookup_by_magic_number(props.fetch("init_pos_type"))
            info.imode_info
          end
        end
      end

      # 手合割
      def preset_info
        @preset_info ||= PresetMagicNumberInfo.fetch_by_magic_number(props.fetch("handicap")).preset_info
      end

      # 初期配置
      # 平手でも入ってる。必ず入ってる。
      def starting_position
        @starting_position ||= props.fetch("init_sfen_position")
      end

      # 結末
      def final_info
        if final_key
          FinalInfo.fetch(final_key)
        end
      end

      # 両者
      # 先後名は props.fetch("gote"), props.fetch("gote") で取れるが
      # mock の都合で key から取得している
      def memberships
        [
          {
            :user_key   => key.user_key_at(:black),
            :grade_info => magic_number_to_grade_info("sente_dan"),
            :judge_info => judge_info_for("SENTE"),
          },
          {
            :user_key   => key.user_key_at(:white),
            :grade_info => magic_number_to_grade_info("gote_dan"),
            :judge_info => judge_info_for("GOTE"),
          },
        ]
      end

      # 勝った側
      def winner_location
        Bioshogi::Location.fetch_if(win_index)
      end

      # 対局後か？
      def battle_done?
        props["result"].present?
      end

      # 対局中か？
      def battle_now?
        !battle_done?
      end

      # 亜流の棋譜
      def csa_seq
        @csa_seq ||= yield_self do
          if v = props["moves"]
            v.collect { |e| [e["m"], e["t"]] }
          end
        end
      end

      # 取り込むべきか？
      def valid?
        # opponent_type = 4 の場合が謎なので取り込まない → あとでわかったが4はラーニング
        unless xmode_info
          return false
        end

        # 手数が1024以上になると DRAW_PLY_LIMIT が入る
        # 2020-11上旬に新しくウォーズに入った仕様っぽい
        # これを取り込んでもあまり意味がないので除外する
        if props["result"] == "DRAW_PLY_LIMIT"
          return false
        end

        # 2021-03-27 緊急メンテナンスが入った日
        # 本家では「対局無効」と表示されている
        if props["result"] == "DRAW_INVALID"
          return false
        end

        # 2025-07-30 この日のメンテナンスが入ったときに対局中だった対局の結果がこうなっていた
        # おそらく最近入ったと思われる仕様
        # これを取り込んでも意味がないので除外する
        if props["result"] == "DRAW_MAINTENANCE"
          return false
        end

        # 対局中や引き分けのときは棋譜がない
        if props["moves"].blank?
          return false
        end

        true
      end

      # 取り込まないべきか？
      def invalid?
        !valid?
      end

      # すでに登録済み？
      def battle_exist?
        Battle.exists?(key: key.to_s)
      end

      private

      def magic_number_to_grade_info(column)
        magic_number = props.fetch(column)
        name = magic_number_to_grade_key(magic_number)
        GradeInfo.fetch(name)
      end

      # マジックナンバーをまともな名前に直す
      #
      #  -2 → "2級"
      #  -1 → "1級"
      #   0 → "初段"
      #   1 → "二段"
      #   2 → "三段"
      #
      def magic_number_to_grade_key(v)
        if v.negative?
          "#{-v}級"
        else
          "初二三四五六七八九十"[v] + "段"
        end
      end

      def rule_key
        @rule_key ||= props.fetch("gtype")
      end

      def judge_key_for(player_name)
        if v = win_side_name
          if v == player_name
            :win
          else
            :lose
          end
        else
          :draw
        end
      end

      def judge_info_for(name)
        JudgeInfo.fetch(judge_key_for(name))
      end

      begin
        def win_index
          if v = win_side_name
            if v == "SENTE"
              0
            else
              1
            end
          end
        end

        def win_side_name
          if v = result_md
            v[:prefix]
          end
        end

        def final_key
          if v = result_md
            v[:final_key] # TORYO 系
          else
            props["result"] # OUTE_SENNICHI 系
          end
        end

        # result は情報が混在しているため分離する
        # props["result"] は対局中の場合は無い
        # https://github.com/tosh1ki/shogiwars
        # "SENTE_WIN_DISCONNECT"
        def result_md
          @result_md ||= (props["result"] || "").match(/\A(?<prefix>\w+)_WIN_(?<final_key>\w+)/)
        end
      end
    end
  end
end
