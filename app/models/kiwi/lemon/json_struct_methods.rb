module Kiwi
  class Lemon
    concern :JsonStructMethods do
      class_methods do
        def json_struct_for_list
          {
            # only: [...], # all
            include: {
              :user => {
                only: [
                  :id,
                  :name,
                ],
              },
              :banana => {        # すでに動画ライブラリに結びついているか確認するため
                only: [
                  :key,
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
