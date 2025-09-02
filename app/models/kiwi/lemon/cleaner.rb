# public/system/x-files 以下の、ライブラリ登録されていないLemonのレコードに結びついた mp4 を削除する
# rails r Kiwi::Lemon.cleaner

module Kiwi
  class Lemon
    class Cleaner
      class << self
        def call(...)
          new(...).call
        end
      end

      def initialize(options = {})
        @options = {
          :execute    => false,
          :expires_in => Rails.env.production? ? 30.days : 0.days,
        }.merge(options)
      end

      def call
        @scope = Lemon.single_only.old_only(@options[:expires_in])
        @count = @scope.count
        @target_records_t = @scope.collect(&:info).to_t
        @target_files = @scope.flat_map { |e| e.related_output_files || [] }
        if @options[:execute]
          @scope.destroy_all
        end
        AppLog.important(subject: subject, body: body)
      end

      private

      def subject
        [
          "動画削除",
          "#{@count}個",
        ].join(" ")
      end

      def body
        [
          "▼オプション",
          @options.to_t,
          "",
          "▼削除したレコード",
          @target_records_t,
          "",
          "▼削除したファイル",
          @target_files.to_t,
        ].compact.collect(&:strip).join("\n")
      end
    end
  end
end
