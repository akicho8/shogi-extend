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
            Importer::AllRuleImporter.new(user_key: "DevUser1").run
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
              battle.preset = Preset.fetch(params[:preset_key])
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
      end
    end
  end
end
