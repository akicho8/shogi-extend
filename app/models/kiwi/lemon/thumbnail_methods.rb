module Kiwi
  class Lemon
    concern :ThumbnailMethods do
      included do
        after_destroy_commit :thumbnail_clean
      end

      def thumbnail_build(pos)
        if command = thumbnail_build_command(pos)
          Bioshogi::SystemSupport.strict_system(command)
        end
      end

      def thumbnail_build_command(pos)
        if thumbnail_real_path
          "ffmpeg -v warning -hide_banner -ss #{pos.clamp(0, ffmpeg_ss_option_max)} -i #{real_path} -vframes 1 -f image2 -y #{thumbnail_real_path}"
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

      def duration
        if ffprobe_info
          ffprobe_info[:direct_format]["streams"][0]["duration"].to_f
        end
      end

      # 5.1 秒の動画で -ss 5 は失敗するため -ss 4 までとする
      # 0.5 秒の動画なら -ss 0 とする
      def ffmpeg_ss_option_max
        if duration
          v = duration.truncate.pred
          if v < 0
            v = 0
          end
          v
        end
      end
    end
  end
end
