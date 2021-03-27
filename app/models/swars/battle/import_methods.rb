module Swars
  class Battle
    concern :ImportMethods do
      class_methods do
        def setup(options = {})
          super

          if Rails.env.development?
            create!
          end

          if Rails.env.development?
            user_import(user_key: "devuser1")
            if ENV["IT_IS_CALLED_THE_CRAWLER_AT_THE_TIME_OF_SETUP"]
              puts Crawler::RegularCrawler.new.run.rows.to_t
              puts Crawler::ExpertCrawler.new.run.rows.to_t
            end
            find_each(&:remake)
          end

          # rails r 'Swars::Battle.create!; tp Swars::Battle'
          if Rails.env.development? && (ENV["SEED_GAME_RECORD_BOUNDARY_LINE_CHECK_FOR_DATA_INPUT_OF_THE_PAPER"] || true)
            tp "棋譜用紙の境界線チェック用データ投入"
            [
              { turn_max:   0, preset_key: "平手",   },
              { turn_max:   1, preset_key: "平手",   },
              { turn_max: 149, preset_key: "平手",   },
              { turn_max: 150, preset_key: "平手",   },
              { turn_max: 151, preset_key: "平手",   },
              { turn_max:   0, preset_key: "香落ち", },
              { turn_max:   1, preset_key: "香落ち", },
              { turn_max: 149, preset_key: "香落ち", },
              { turn_max: 150, preset_key: "香落ち", },
              { turn_max: 151, preset_key: "香落ち", },
              { turn_max: 152, preset_key: "香落ち", },
            ].each do |params|
              user1 = User.create!(user_key: SecureRandom.hex[0...5])
              user2 = User.create!(user_key: SecureRandom.hex[0...5])

              if params[:preset_key] == "平手"
                list = [["+5958OU", 0], ["-5152OU", 0], ["+5859OU", 0], ["-5251OU", 0]]
              else
                list = [["-5152OU", 0], ["+5958OU", 0], ["-5251OU", 0], ["+5859OU", 0]]
              end

              cycle = list.cycle

              battle = Battle.new
              battle.preset_key = params[:preset_key]
              battle.csa_seq = params[:turn_max].times.collect { cycle.next }
              battle.memberships.build(user: user1, judge_key: :win,  location_key: :black)
              battle.memberships.build(user: user2, judge_key: :lose, location_key: :white)
              battle.battled_at = Time.current
              battle.save!
            end
          end
        end

        # def run(...)
        #   import(...)
        # end

        # cap production rails:runner CODE='Swars::Battle.remake'
        def remake(params = {})
          params = {
            limit: 256,
          }.merge(params)

          c = Hash.new(0)
          all.order(accessed_at: :desc).limit(params[:limit]).each do |e|
            c[e.remake] += 1
          end
          puts
          p c
        end

        def throttle_user_import(params = {})
          params = {
            seconds: throttle_user_import_skip_seconds_default,
          }.merge(params)

          if params[:force]
            throttle_user_import_cache_delete(params)
          end

          # キャッシュの有効時間のみ利用して連続実行を防ぐ
          cache_key = throttle_user_import_cache_key(params)
          if Rails.cache.exist?(cache_key)
            return false
          end
          Rails.cache.write(cache_key, true, expires_in: params[:seconds])

          user_import(params)
          true
        end

        def throttle_user_import_cache_delete(params)
          Rails.cache.delete(throttle_user_import_cache_key(params))
        end

        def throttle_user_import_cache_key(params)
          ["throttle_user_import", params[:user_key], params[:page_max]].join("/")
        end

        def throttle_user_import_skip_seconds_default
          if Rails.env.production? || Rails.env.staging?
            3.minutes
          else
            10.seconds
          end
        end

        # Battle.user_import(user_key: "shuei299792458")
        # Battle.user_import(user_key: "DarkPonamin9")
        # Battle.user_import(user_key: "micro77")
        # Battle.user_import(user_key: "micro77", page_max: 3)
        def user_import(params = {})
          RuleInfo.each do |e|
            multiple_battle_import(params.merge(gtype: e.swars_real_key))
          end
        end

        # Battle.multiple_battle_import(user_key: "chrono_", gtype: "")
        def multiple_battle_import(params = {})
          params = {
            verbose: Rails.env.development?,
            early_break: false, # 1ページ目で新しいものが見つからなければ終わる
            error_capture: nil, # blockが渡されていれば呼ぶ
            error_capture_fake: false, # trueならわざと例外
          }.merge(params)

          keys = []
          (params[:page_max] || 1).times do |i|
            page_keys = []
            unless params[:dry_run]
              page_keys = Agent::Index.fetch(params.merge(page_index: i))
            end
            sleep_on(params)

            keys += page_keys

            # アクセス数を減らすために10件未満なら終了する
            if page_keys.size < Agent::Index.items_per_page
              if params[:verbose]
                tp "(#{page_keys.size} < #{Agent::Index.items_per_page}) --> break"
              end
              break
            end

            if params[:early_break]
              # 1ページ目で新しいものがなければ終わる
              new_keys = page_keys - where(key: page_keys).pluck(:key)
              if params[:verbose]
                tp "#{i}ページの新しいレコード数: #{new_keys.size}"
              end
              if new_keys.empty?
                break
              end
            end

            # if Battle.where(key: key).exists?

            # list.each do |history|
            #   key = history[:key]
            #
            #   # すでに取り込んでいるならスキップ
            #   if Battle.where(key: key).exists?
            #     next
            #   end

            # # フィルタ機能
            # if true
            #   # 初段以上の指定がある場合
            #   if v = params[:grade_key_gteq]
            #     v = GradeInfo.fetch(v)
            #     # 取得してないときもあるため
            #     if user_infos = history[:user_infos]
            #       # 両方初段以上ならOK
            #       if user_infos.all? { |e| GradeInfo.fetch(e[:grade_key]).priority <= v.priority }
            #       else
            #         next
            #       end
            #     end
            #   end
            # end
          end

          if params[:error_capture_fake]
          else
            keys = keys - where(key: keys).pluck(:key)
          end

          keys.each do |key|
            begin
              if params[:error_capture_fake]
                raise Bioshogi::BioshogiError, "(test1)\n(test2)\n"
              end
              single_battle_import(params.merge(key: key, skip_if_exist: false))
            rescue Bioshogi::BioshogiError => error
              if f = params[:error_capture]
                f.call({key: key, error: error})
              else
                raise error
              end
            end
            sleep_on(params)
          end
        end

        def single_battle_import(params = {})
          params = {
            verbose: Rails.env.development?,
            skip_if_exist: true,
          }.merge(params)

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
          unless info[:fetch_successed]
            return
          end

          # # 引き分けを考慮すると急激に煩雑になるため取り込まない
          # # ここで DRAW_SENNICHI も弾く
          # unless info[:__final_key].match?(/(SENTE|GOTE)_WIN/)
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

          # 将棋ウォーズのコードがマジックナンバーなため見当つけて変換する
          preset_info = DirtyPresetInfo.fetch("__handicap_embed__#{info[:preset_dirty_code]}").real_preset_info

          battle = Battle.new({
              key: info[:key],
              rule_key: info[:rule_key],
              csa_seq: info[:csa_seq],
              preset_key: preset_info.key,
            })

          if md = info[:__final_key].match(/\A(?<prefix>\w+)_WIN_(?<final_key>\w+)/)
            winner_index = md[:prefix] == "SENTE" ? 0 : 1
            battle.final_key = md[:final_key]
          else
            winner_index = nil
            battle.final_key = info[:__final_key]
          end

          info[:user_infos].each.with_index do |e, i|
            user = User.find_by!(user_key: e[:user_key])
            grade = Grade.fetch(e[:grade_key])

            if winner_index
              judge_key = (i == winner_index) ? :win : :lose
            else
              judge_key = :draw
            end

            battle.memberships.build(user: user, grade: grade, judge_key: judge_key, location_key: Bioshogi::Location.fetch(i).key)
          end

          # SQLをシンプルにするために勝者だけ、所有者的な意味で、Battle 自体に入れとく
          # いらんかったらあとでとる
          # if winner_index
          #   battle.win_user = battle.memberships[winner_index].user
          # end

          begin
            battle.save!
          rescue ActiveRecord::RecordNotUnique, ActiveRecord::Deadlocked => error
            Rails.logger.info(error.inspect)
            false
          end
        end

        private

        def sleep_on(params)
          if params[:dry_run]
            return
          end

          if v = params[:sleep]
            v = v.to_f
            if v.positive?
              if params[:verbose]
                tp "sleep: #{v}"
              end
              sleep(v)
            end
          end
        end
      end
    end
  end
end
