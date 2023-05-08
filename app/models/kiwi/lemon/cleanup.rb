# rails r Kiwi::Lemon.cleanup

module Kiwi
  class Lemon
    class Cleanup
      def initialize(options = {})
        @options = {
          execute: false,
          expires_in: Rails.env.production? ? 30.days : 0.days,
        }.merge(options)
      end

      def call
        @scope = Lemon.single_only.old_only(@options[:expires_in])
        @table = @scope.collect(&:info).to_t
        @free_info = df_block do
          if @options[:execute]
            @scope.destroy_all
          end
        end
        SystemMailer.notify(fixed: true, subject: "動画削除 #{df_run}", body: body).deliver_later
      end

      private

      def df_block
        av = []
        av << df_run
        yield
        av << df_run
        av
      end

      def df_run
        `df -H /`.lines.last.strip
      end

      def body
        [
          @free_info.to_t,
          @table,
          @options.to_t,
        ].compact.collect(&:strip).join("\n")
      end
    end
  end
end
