module Swars
  module ZipDl
    class Summary
      def initialize(main_builder)
        @main_builder = main_builder
      end

      def to_s
        a = []
        a << "#{@main_builder.current_user.name}(#{@main_builder.current_user.swars_zip_dl_logs.count}):"
        a << @main_builder.swars_user.key
        a << @main_builder.zip_dl_scope_info.name
        a << "#{@main_builder.zip_dl_scope.count}件"
        if @main_builder.processed_sec
          a << "%.2fs" % @main_builder.processed_sec
        end
        # if limiter.over?
        #   a << "制#{limiter.recent_count}"
        # end
        a << @main_builder.zip_filename
        a.join(" ")
      end
    end
  end
end
