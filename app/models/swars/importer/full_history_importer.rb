module Swars
  module Importer
    class FullHistoryImporter < Base
      def call
        HistoryAccessPatterns.each do |pattern|
          SingleHistoryImporter.new(params.merge(pattern)).call
        end
        crawl_timestamp_columns_update
      end

      private

      def crawl_timestamp_columns_update
        if user
          begin
            Retryable.retryable(on: ActiveRecord::Deadlocked) do
              now = Time.current
              attrs = { soft_crawled_at: now }
              if params[:eager_to_next_page]
                attrs[:hard_crawled_at] = now
              end
              user.update_columns(attrs)
            end
          rescue ActiveRecord::Deadlocked => error
            AppLog.important(error, data: params)
          end
        end
      end

      def user
        @user ||= User[params[:user_key]]
      end
    end
  end
end
