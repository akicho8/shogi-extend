module Swars
  module Importer
    class SingleBattleImporter
      attr_accessor :params

      # Importer::SingleBattleImporter.new(user_key: "chrono_", gtype: "").run
      def initialize(params = {})
        @params = {
          verbose: Rails.env.development?,
          skip_if_exist: true,
        }.merge(params)
      end

      def run
        # 登録済みなら戻る
        if params[:skip_if_exist]
          if Battle.where(key: params[:key]).exists?
            return
          end
        end

        info = Agent::Record.fetch(params)

        # 手数が1024以上になると DRAW_PLY_LIMIT が入る
        # 2020-11上旬に新しくウォーズに入った仕様っぽい
        # これを取り込んでもあまり意味がないので弾く
        if info[:__final_key] == "DRAW_PLY_LIMIT"
          return
        end
        # 2021-03-27 緊急メンテナンスが入った日。
        # 本家では「対局無効」と表示されている
        if info[:__final_key] == "DRAW_INVALID"
          return
        end

        # 対局中や引き分けのときは棋譜がないのでスキップ
        if !info[:fetch_successed]
          return
        end

        # # 引き分けを考慮すると急激に煩雑になるため取り込まない
        # # ここで DRAW_SENNICHI も弾く
        # if !info[:__final_key].match?(/(SENTE|GOTE)_WIN/)
        #   return
        # end

        users = info[:user_infos].collect do |e|
          User.find_or_initialize_by(user_key: e[:user_key]).tap do |user|
            grade = Grade.fetch(e[:grade_key])
            user.grade = grade # 常にランクを更新する
            begin
              user.save!
            rescue ActiveRecord::RecordNotUnique
            end
          end
        end

        preset_key = PresetMagicNumberInfo.by_magick_number(info[:preset_magic_number]).preset_info.key

        battle = Battle.new({
            :key        => info[:key],
            :rule_key   => info[:rule_key],
            :csa_seq    => info[:csa_seq],
            :preset_key => preset_key,
            # :preset     => Preset.fetch(preset_key),
            :xmode      => XmodeMagicNumberInfo.fetch("magic_number_is_#{info[:xmode_magic_number]}").xmode,
          })

        if md = info[:__final_key].match(/\A(?<prefix>\w+)_WIN_(?<final_key>\w+)/)
          winner_index = md[:prefix] == "SENTE" ? 0 : 1
          battle.final_key = md[:final_key]
        else
          winner_index = nil
          battle.final_key = info[:__final_key]
        end

        info[:user_infos].each.with_index do |e, i|
          if winner_index
            judge_key = (i == winner_index) ? :win : :lose
          else
            judge_key = :draw
          end
          membership = battle.memberships.build({
              :user         => User.find_by!(user_key: e[:user_key]),
              :grade        => Grade.fetch(e[:grade_key]),
              :judge_key    => judge_key,
              :location_key => LocationInfo.fetch(i).key,
            })

          # membership.build_membership_extra(used_piece_counts: {[:foo, true] => 1})
          # membership.build_membership_extra
        end

        # SQLをシンプルにするために勝者だけ、所有者的な意味で、Battle 自体に入れとく
        # いらんかったらあとでとる
        # if winner_index
        #   battle.win_user = battle.memberships[winner_index].user
        # end

        begin
          battle.save!
        rescue ActiveRecord::RecordNotUnique, ActiveRecord::Deadlocked => error # RecordNotUnique は DB の unique index 違反
          Rails.logger.info { error.inspect }
          false
        end
      end
    end
  end
end
