module Kiwi
  class Lemon
    concern :ThumbnailMethods do
      included do
        after_destroy_commit :thumbnail_clean
      end

      def thumbnail_build(ss)
        if thumbnail_real_path
          Bioshogi::SystemSupport.strict_system "ffmpeg -v warning -hide_banner -ss #{ss} -i #{real_path} -vframes 1 -f image2 -y #{thumbnail_real_path}"
        end
      end

      def thumbnail_real_path
        if recipe_info.thumbnail_p
          if browser_path
            real_path.sub_ext("_thumbnail.png")
          end
        end
      end

      def thumbnail_browser_path
        if v = thumbnail_real_path
          "/" + v.relative_path_from(Rails.public_path).to_s
        end
      end

      def thumbnail_browser_path_if_exist
        if e = thumbnail_real_path
          if e.exist?
            thumbnail_browser_path
          end
        end
      end

      def thumbnail_clean
        if v = thumbnail_real_path
          FileUtils.rm_f(v)
        end
      end

      def og_image_path
        thumbnail_browser_path_if_exist || browser_path
      end

      def og_video_path
        if recipe_info.og_video
          browser_path
        end
      end
    end
  end
end
