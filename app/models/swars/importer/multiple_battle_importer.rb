module Swars
  module Importer
    class MultipleBattleImporter
      attr_accessor :params

      # Importer::MultipleBattleImporter.new(user_key: "chrono_", gtype: "").run
      def initialize(params = {})
        @params = {
          :verbose            => Rails.env.development?,
          :early_break        => false, # 1ページ目で新しいものが見つからなければ終わる
          :error_capture      => nil,   # blockが渡されていれば呼ぶ
          :error_capture_fake => false, # trueならわざと例外
        }.merge(params)
      end

      def run
        if params[:SwarsFormatIncompatible]
          raise Agent::SwarsFormatIncompatible
        end

        keys = []
        (params[:page_max] || 1).times do |i|
          page_keys = []
          if !params[:dry_run]
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
          keys = keys - Battle.where(key: keys).pluck(:key)
        end

        keys.each do |key|
          begin
            if params[:error_capture_fake]
              raise Bioshogi::BioshogiError, "(test1)\n(test2)\n"
            end
            SingleBattleImporter.new(params.merge(key: key, skip_if_exist: false)).run
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
