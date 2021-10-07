module Kiwi
  class Book
    concern :JsonStructMethods do
      class_methods do
        def json_struct_for_top
          {
            only: [
              :key,
              :title,
              :description,
              :created_at,
              :updated_at,
              :access_logs_count,
              :book_messages_count,
            ],
            methods: [
              :folder_key,
              :tag_list,
            ],
            include: {
              **user_struct,
              **lemon_struct,
            },
          }
        end

        def json_struct_for_index
          {
            only: [
              :key,
              :title,
              :updated_at,
              :access_logs_count,
              :book_messages_count,
            ],
            methods: [
              :folder_key,
              :tweet_body,
              :page_url,
              :tag_list,
            ],
            include: {
              **user_struct,
              **lemon_struct,
            },
          }
        end

        def json_struct_for_edit
          {
            only: [
              :id,
              :key,
              :title,
              :description,
              :lemon_id,
              :thumbnail_pos,
            ],
            methods: [
              :folder_key,
              :tag_list,
            ],
            include: {
              user: {
                only: [
                  :id,
                  :key,
                ],
              },
              lemon: {
                only: [
                  :browser_path,
                  :filename_human,
                  :content_type,
                  :all_params,
                ],
                methods: [
                  :thumbnail_browser_path,
                ],
              }
            },
          }
        end

        def json_struct_for_show
          {
            only: [
              :id,
              :key,
              :title,
              :description,
              :created_at,
              :updated_at,
              :access_logs_count,
              :book_messages_count,
            ],
            methods: [
              :folder_key,
              :tweet_body,
              :og_meta,
              :tag_list,
              :advanced_kif_info,
            ],
            include: {
              **user_struct,
              **lemon_struct,
              **book_messages_struct,
            },
          }
        end

        def lemon_struct
          {
            lemon: {
              only: [
                :browser_path,
                :filename_human,
                :content_type,
                # :all_params,
              ],
              methods: [
                :thumbnail_browser_path,
              ],
            }
          }
        end

        def user_struct
          {
            user: {
              only: [
                :id,
                :key,
                :name,
              ],
              methods: [
                :avatar_path,
              ],
            },
          }
        end

        def book_messages_struct
          {
            book_messages: {
              **BookMessage.json_struct_type8,
            },
          }
        end
      end
    end
  end
end
