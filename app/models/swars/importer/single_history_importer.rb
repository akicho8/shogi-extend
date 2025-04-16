module Swars
  module Importer
    class SingleHistoryImporter < Base
      def default_params
        {
          :verbose => Rails.env.development?,
        }
      end

      def call
        validate!
        new_keys.each(&method(:import_process))
      end

      private

      def validate!
        if params[:eager_to_next_page] && look_up_to_page_x <= 1
          raise ArgumentError, "「取り込むべき棋譜が0件のページがあっても次のページを見る」としているのに参照する最大ページ数が 2 以上になっていない"
        end
      end

      # 対象ルールのすべての(まだDBには取り込んでいない)対局キーたちを集める
      def new_keys
        @new_keys ||= [].tap do |new_keys|
          look_up_to_page_x.times do |i|
            history_box = Agent::History.new(params.merge(page_index: i)).fetch
            log_puts { [params[:user_key], "Page#{i.next}", rule_name, history_box.inspect].join(" ") }
            new_keys.concat(history_box.new_keys)
            if history_box.last_page?
              log_puts { "  BREAK (最後のページと思われるので終わる)" }
              break
            end
            if look_up_to_page_x > 1
              if params[:eager_to_next_page]
                # 新しい対局が見つからなくても次のページに進む (遅いが過去の棋譜を落とせる)
              else
                if history_box.new_keys.empty?
                  log_puts { "  BREAK (このページには新しい対局が見つからなかったので以降のページには新しい対局がないものと考えて終わる)" }
                  break
                end
              end
            end
          end
        end
      end

      def import_process(key)
        begin
          if params[:bs_error_capture_fake]
            raise Bioshogi::BioshogiError, "(test1)\n(test2)\n"
          end
          BattleImporter.new(params.merge(key: key)).call
        rescue Bioshogi::BioshogiError => error
          if f = params[:bs_error_capture_block]
            f.call({ key: key, error: error })
          else
            raise error
          end
        end
      end

      def rule_name
        if v = params[:rule_key]
          RuleInfo.fetch(v).name
        else
          "ルール未指定"
        end
      end

      def log_puts
        if !params[:verbose]
          return
        end
        puts yield
      end

      def look_up_to_page_x
        params[:look_up_to_page_x] || 1
      end
    end
  end
end
