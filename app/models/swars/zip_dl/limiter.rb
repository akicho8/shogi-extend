module Swars
  module ZipDl
    class Limiter
      cattr_accessor(:recent_period) { 1.days } # 直近のこの期間に

      # これだけDLすると禁止 (DL数回数ではなくDLに含む棋譜総数)
      cattr_accessor(:recent_count_max) {
        if Rails.env.development?
          3
        elsif Rails.env.test?
          3
        else
          50 * 10
        end
      }

      def initialize(main_builder)
        @main_builder = main_builder
      end

      # 直近のダウンロード数が多すぎるか？
      def over?
        recent_count >= recent_count_max
      end

      # 直近のダウンロード棋譜総数。テストできなくなるためメモ化禁止。
      def recent_count
        @main_builder.current_user.swars_zip_dl_logs.recent_only(recent_period).sum(:dl_count)
      end

      # 直近のダウンロード数が多すぎるときのエラーメッセージ
      def message
        if over?
          [
            "短時間にダウンロードする棋譜の総数が多すぎます。",
            "しばらくしてからお試しください。",
            "「前回の続きから」を使って差分だけを取得するとこの制限が出にくくなります。",
          ].join
        end
      end

      def as_json(*)
        if @main_builder.current_user
          {
            :over_p           => over?,            # ダウンロード禁止状態か？
            :message          => message,          # 禁止メッセージ
            # 以下はJS側では未使用
            :recent_count     => recent_count,     # 最近のダウンロード数
            :recent_period    => recent_period,    # 直近のこの期間に
            :recent_count_max => recent_count_max, # これだけDLすると禁止 (DL数回数ではなくDLに含む棋譜総数)
          }
        end
      end
    end
  end
end
