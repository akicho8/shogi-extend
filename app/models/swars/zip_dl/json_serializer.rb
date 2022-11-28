module Swars
  module ZipDl
    class JsonSerializer
      def initialize(main_builder)
        @main_builder = main_builder
      end

      def as_json
        {
          :form_params_default => form_params_default,
          :swars_zip_dl_logs   => swars_zip_dl_logs,
          :limiter             => @main_builder.limiter,
          :scope_info          => scope_info,
        }
      end

      private

      def form_params_default
        {
          :zip_dl_scope_key     => "zdsk_inherit",
          :zip_dl_format_key    => "kif",
          :zip_dl_max           => AppConfig[:zip_dl_max_default],
          :zip_dl_structure_key => "date",
          :body_encode          => "UTF-8",
        }
      end

      def swars_zip_dl_logs
        if @main_builder.current_user
          s = @main_builder.swars_zip_dl_logs.order(:end_at)
          {
            :count => s.count,
            :last  => s.last,
          }
        end
      end

      def scope_info
        ScopeInfo.inject({}) do |a, e|
          a.merge(e.key => {
              :key     => e.key,
              :name    => e.name,
              :count   => e.scope.call(@main_builder).count,
              :message => e.message.call(@main_builder),
            })
        end
      end
    end
  end
end
