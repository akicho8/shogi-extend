module Kiwi
  class Lemon
    concern :ThumbnailMethods do
      def thumbnail_build
        raise "thumbnail_real_path is blank" if thumbnail_real_path.blank?                                # /system/x-files/0f/16/3_20210925101219_2x2_3s.mp4
        `ffmpeg -ss 00:00:00 -i #{real_path} -vframes 1 -f image2 -y #{thumbnail_real_path}`

        # old = media_builder.real_path               # 生成ファイル ~/src/shogi-extend/public/system/x-files/3e/3d/3e3dae2e6ad07d51fe12e171ebb337b6.mp4
        # new = old.dirname + filename_human          # 人間向け参照 ~/src/shogi-extend/public/system/x-files/3e/3d/2_20210824130750_1024x768_8s.mp4
        # if rename
        #   FileUtils.mv(old, new)
        #   FileUtils.mv("#{old}.rb", "#{new}.rb")
        # else
        #   # NOTE: フルパスでsymlinkするとデプロイでパスが切れてしまう
        #   Dir.chdir(old.dirname) do
        #     FileUtils.symlink(old.basename, new.basename, force: true)
        #   end
        # end
        #
        #
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

      class_methods do
        def json_struct_for_list
          {
            # only: [
            #   # all
            # ],
            include: {
              :user => {
                only: [
                  :id,
                  :name,
                ],
              },
            },
            methods: [
              :status_key,
              :thumbnail_browser_path,
            ],
          }
        end

        def json_struct_for_done_record
          json_struct_for_list
        end
      end
    end
  end
end
