# 続きからダウンロード関連
#
# UI
# nuxt_side/components/Swars/SwarsBattleDownload.vue
#
# ダウンロード記録
# app/models/swars/zip_dl_log.rb
#
# スコープ別の処理
# app/models/swars/zip_dl/scope_info.rb
#
# Controller
# app/models/swars/zip_dl/action_methods.rb
#
# Experiment
# playground/swars/zip_dl/main_builder.rb
#
# Test
# spec/models/swars/zip_dl/main_builder_spec.rb

module Swars
  module ZipDl
    class MainBuilder
      include EncodeMethods
      include SortMethods

      attr_accessor :params
      attr_accessor :processed_sec

      def initialize(params)
        @params = params
      end

      # JS側のコンポーネントに渡す
      # --> action_methods.rb
      def as_json(*)
        JsonSerializer.new(self)
      end

      def to_zip
        io = nil
        @processed_sec = Benchmark.realtime { io = to_zip_output_stream }
        SlackAgent.notify(subject: "ウォーズ棋譜ZIP-DL", body: to_summary)

        # 前回から続きのスコープが変化すると zip_filename にも影響するので最後の最後に呼ぶ
        swars_zip_dl_logs_create!

        io
      end

      def to_summary
        Summary.new(self).to_s
      end

      def to_zip_output_stream
        ZipBuilder.new(self).to_zip_output_stream
      end

      # 何度DLしても同じデータならファイル名は同じになるようにしている
      def zip_filename
        FilenameBuilder.new(self).to_s
      end

      # 続きから進められるようにダウンロード範囲を記録する
      def swars_zip_dl_logs_create!
        log_create(zip_dl_scope)
      end

      # 古い1件をダウンロードしたことにする
      def oldest_log_create
        scope = current_index_scope.order(battled_at: :asc).limit(1)
        log_create(scope)
      end

      def limiter
        @limiter ||= Limiter.new(self)
      end

      def swars_user
        params[:swars_user] or raise ArgumentError
      end

      def current_user
        params[:current_user] or raise ArgumentError
      end

      def zip_dl_scope_info
        ScopeInfo.fetch(zip_dl_scope_key)
      end

      def zip_dl_scope
        zip_dl_scope_info.scope.call(self)
      end

      def kifu_format_info
        @kifu_format_info ||= Bioshogi::KifuFormatInfo.fetch(zip_dl_format_info.key)
      end

      def zip_dl_structure_key
        (params[:zip_dl_structure_key].presence || "date").to_sym
      end

      def swars_zip_dl_logs
        @swars_zip_dl_logs ||= current_user.swars_zip_dl_logs.where(swars_user: swars_user)
      end

      def current_index_scope
        params[:current_index_scope] or raise ArgumentError
      end

      def zip_dl_max
        (params[:zip_dl_max].presence || AppConfig[:zip_dl_max_default]).to_i.clamp(0, AppConfig[:zip_dl_max_of_max])
      end

      def continue_begin_at
        if current_user
          if e = swars_zip_dl_logs.order(:end_at).last
            e.end_at
          end
        end
      end

      private

      # 続きから進められるようにダウンロード範囲を記録する
      def log_create(s)
        if s.exists? && current_user
          a = s.first.battled_at
          b = s.last.battled_at
          a, b = [a, b].sort
          current_user.swars_zip_dl_logs.create! do |e|
            e.swars_user = swars_user
            e.query      = params[:query]
            e.dl_count   = s.count
            e.begin_at   = a            # 単なる記録なのでなくてもよい
            e.end_at     = b + 1.second # 次はこの日時以上を対象にする
          end
        end
      end

      def zip_dl_format_info
        ZipDlFormatInfo.fetch(zip_dl_format_key)
      end

      def zip_dl_format_key
        params[:zip_dl_format_key].presence || "kif"
      end

      def zip_dl_scope_key
        (params[:zip_dl_scope_key].presence || "zdsk_inherit").to_sym
      end
    end
  end
end
