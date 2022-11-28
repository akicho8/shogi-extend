module Swars
  module ZipDl
    class FilenameBuilder
      def initialize(main_builder)
        @main_builder = main_builder
      end

      def to_s
        parts = []
        parts << "shogiwars"
        parts << @main_builder.swars_user.key
        parts << @main_builder.zip_dl_scope.count
        parts << latest_battled_at.strftime("%Y%m%d%H%M%S")
        parts << @main_builder.kifu_format_info.key
        parts << @main_builder.current_body_encode
        str = parts.compact.join("-") + ".zip"
        str
      end

      private

      def latest_battled_at
        (@main_builder.zip_dl_scope.to_a.collect(&:battled_at).max || Time.current)
      end
    end
  end
end
