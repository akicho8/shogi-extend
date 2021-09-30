module Kiwi
  class Lemon
    concern :ThumbnailMethods do
      def thumbnail_build(ss)
        raise "thumbnail_real_path is blank" if thumbnail_real_path.blank?
        safe_system("ffmpeg -v warning -hide_banner -ss #{ss} -i #{real_path} -vframes 1 -f image2 -y #{thumbnail_real_path}")
      end

      def thumbnail_real_path
        if browser_path
          real_path.sub_ext("_thumbnail.png")
        end
      end

      def thumbnail_browser_path
        if v = thumbnail_real_path
          "/" + v.relative_path_from(Rails.public_path).to_s
        end
      end
    end
  end
end
