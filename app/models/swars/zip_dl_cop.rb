# 続きからダウンロード関連
#
# UI
# nuxt_side/components/Swars/SwarsBattleDownload.vue
#
# ダウンロード記録
# app/models/swars/zip_dl_log.rb
#
# スコープ別の処理
# app/models/swars/zip_dl_scope_info.rb
#
# Controller
# app/controllers/swars/zip_dl_methods.rb
#
# Experiment
# experiment/swars/zip_dl_cop.rb
#
# Test
# spec/models/swars/zip_dl_cop_spec.rb

require "active_support/core_ext/benchmark"

module Swars
  class ZipDlCop
    cattr_accessor(:dli_recent_period)    { 1.days  } # 直近のこの期間に
    cattr_accessor(:dli_recent_count_max) { 50 * 10 } # これだけDLすると禁止 (DL数回数ではなくDLに含む棋譜総数)

    if Rails.env.development?
      self.dli_recent_count_max = 3 # これだけDLすると禁止 (DL数回数ではなくDLに含む棋譜総数)
    end

    include EncodeMethods
    include SortMethods

    attr_accessor :params

    def initialize(params)
      @params = params
    end

    # JS側のコンポーネントに渡す
    # --> ~/src/shogi-extend/app/controllers/swars/zip_dl_methods.rb
    def to_config
      config = {}
      config[:form_params_default] = {
        :zip_dl_scope_key     => "zdsk_inherit",
        :zip_dl_format_key    => "kif",
        :zip_dl_max           => AppConfig[:zip_dl_max_default],
        :zip_dl_structure_key => "date",
        :body_encode          => "UTF-8",
      }

      if current_user
        s = swars_zip_dl_logs
        s = s.order(:end_at)
        config[:swars_zip_dl_logs] = {
          :count => s.count,
          :last  => s.last,
        }

        config[:dl_limit_info] = {
          :dli_over_p           => dli_over?,            # ダウンロード禁止状態か？
          :dli_message          => dli_message,          # 禁止メッセージ
          # 以下はJS側では未使用
          :dli_recent_count     => dli_recent_count,     # 最近のダウンロード数
          :dli_recent_period    => dli_recent_period,    # 直近のこの期間に
          :dli_recent_count_max => dli_recent_count_max, # これだけDLすると禁止 (DL数回数ではなくDLに含む棋譜総数)
        }
      end

      config[:scope_info] = ZipDlScopeInfo.inject({}) do |a, e|
        a.merge(e.key => {
            :key     => e.key,
            :name    => e.name,
            :count   => instance_eval(&e.scope).count,
            :message => instance_eval(&e.message),
          })
      end

      config
    end

    def to_zip
      io = nil
      @processed_sec = Benchmark.realtime { io = to_zip_output_stream }
      SlackAgent.message_send(key: "ウォーズ棋譜ZIP-DL", body: to_summary)

      # 前回から続きのスコープが変化すると zip_filename にも影響するので最後の最後に呼ぶ
      swars_zip_dl_logs_create!

      io
    end

    def to_summary
      a = []
      a << "#{current_user.name}(#{current_user.swars_zip_dl_logs.count}):"
      a << swars_user.key
      a << zip_dl_scope_info.name
      a << "#{zip_dl_scope.count}件"
      if @processed_sec
        a << "%.2fs" % @processed_sec
      end
      # if dli_over?
      #   a << "制#{dli_recent_count}"
      # end
      a << zip_filename
      a.join(" ")
    end

    def to_zip_output_stream
      Zip::OutputStream.write_buffer do |zos|
        zip_dl_scope.each do |battle|
          if str = battle.to_xxx(kifu_format_info.key)
            path = []
            path << swars_user.key
            if zip_dl_structure_key == :date
              path << battle.battled_at.strftime("%Y-%m-%d")
            end
            path << "#{battle.key}.#{kifu_format_info.key}"
            path = path.join("/")

            entry = Zip::Entry.new(zos, path)
            entry.time = Zip::DOSTime.from_time(battle.battled_at)
            zos.put_next_entry(entry)

            if current_body_encode == "Shift_JIS"
              str = str.encode(current_body_encode)
            end
            zos.write(str)
          end
        end
      end
    end

    # 何度DLしても同じデータならファイル名は同じになるようにしている
    def zip_filename
      parts = []
      parts << "shogiwars"
      parts << swars_user.key
      parts << zip_dl_scope.count
      parts << (zip_dl_scope.to_a.collect(&:battled_at).max || Time.current).strftime("%Y%m%d%H%M%S")
      parts << kifu_format_info.key
      parts << current_body_encode
      str = parts.compact.join("-") + ".zip"
      str
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

    if true
      # 直近のダウンロード数が多すぎるか？
      def dli_over?
        dli_recent_count >= dli_recent_count_max
      end

      # 直近のダウンロード棋譜総数
      def dli_recent_count
        @dli_recent_count ||= -> {
          s = current_user.swars_zip_dl_logs
          s = s.where(ZipDlLog.arel_table[:created_at].gteq(dli_recent_period.ago))
          s.sum(:dl_count)
        }.call
      end

      # 直近のダウンロード数が多すぎるときのエラーメッセージ
      def dli_message
        if dli_over?
          [
            "短時間にダウンロードする棋譜の総数が多すぎるためしばらくしてからお試しください。",
            "「前回の続きから」を使って差分だけを取得することで、この制限が出にくくなります。",
          ].join
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

    def zip_dl_scope
      instance_eval(&zip_dl_scope_info.scope)
    end

    def zip_dl_max
      (params[:zip_dl_max].presence || AppConfig[:zip_dl_max_default]).to_i.clamp(0, AppConfig[:zip_dl_max_of_max])
    end

    def kifu_format_info
      @kifu_format_info ||= Bioshogi::KifuFormatInfo.fetch(zip_dl_format_info.key)
    end

    def zip_dl_format_info
      ZipDlFormatInfo.fetch(zip_dl_format_key)
    end

    def zip_dl_format_key
      params[:zip_dl_format_key].presence || "kif"
    end

    def continue_begin_at
      if current_user
        if e = swars_zip_dl_logs.order(:end_at).last
          e.end_at
        end
      end
    end

    def swars_zip_dl_logs
      @swars_zip_dl_logs ||= current_user.swars_zip_dl_logs.where(swars_user: swars_user)
    end

    def zip_dl_scope_info
      ZipDlScopeInfo.fetch(zip_dl_scope_key)
    end

    def zip_dl_scope_key
      (params[:zip_dl_scope_key].presence || "zdsk_inherit").to_sym
    end

    def current_user
      params[:current_user] or raise ArgumentError
    end

    def swars_user
      params[:swars_user] or raise ArgumentError
    end

    def current_index_scope
      params[:current_index_scope] or raise ArgumentError
    end

    def zip_dl_structure_key
      (params[:zip_dl_structure_key].presence || "date").to_sym
    end
  end
end
