module Wkbk
  class Book
    concern :JsonStructMethods do
      class_methods do
        def json_struct_for_top
          {
            only: [
              :key,
              :title,
              :bookships_count,
              :created_at,
              :updated_at,
              :access_logs_count,
            ],
            methods: [
              :folder_key,
              :avatar_path,
              :bookships_count_by_current_user,
              :tag_list,
            ],
            include: {
              user: {
                only: [
                  :id,
                  :name,
                ],
                methods: [
                  :avatar_path,
                ],
              },
            },
          }
        end

        def json_struct_for_index
          {
            only: [
              :key,
              :title,
              :bookships_count,
              :created_at,
              :updated_at,
              :access_logs_count,
            ],
            methods: [
              :folder_key,
              :tweet_body,
              :page_url,
              :avatar_path,
              :tag_list,
            ],
            include: {
              user: {
                only: [
                  :id,
                  :name,
                ],
                methods: [
                  :avatar_path,
                ],
              },
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
              :bookships_count,
              :created_at,
              :updated_at,
              :access_logs_count,
            ],
            methods: [
              :folder_key,
              :sequence_key,
              :tweet_body,
              :raw_avatar_path,
              :tag_list,
            ],
            include: {
              user: {
                only: [
                  :key,
                  :id,
                  :name,
                ],
                methods: [
                  :avatar_path,
                ]
              },
              folder: {
                only: [
                  :key,
                  :id,
                  :name,
                ],
              },
              ordered_bookships: {
                only: [
                  :id,
                  :created_at,
                ],
                include: {
                  article: {
                    only: [
                      :key,
                      :title,
                      :difficulty,
                      :turn_max,
                      :created_at,
                      :updated_at,
                    ],
                    methods: [
                      :folder_key,
                    ],
                  },
                },
              },
            },
          }
        end

        # 出題
        def json_struct_for_show
          {
            only: [
              :id,
              :key,
              :title,
              :description,
              :bookships_count,
              :created_at,
              :updated_at,
              :access_logs_count,
            ],
            methods: [
              :folder_key,
              :sequence_key,
              :tweet_body,
              :og_meta,
              :avatar_path,
              :tag_list,
            ],
            include: {
              user: {
                only: [
                  :key,
                  :id,
                  :name,
                ],
                methods: [
                  :avatar_path,
                ],
              },
              folder: {
                only: [
                  :key,
                  :id,
                  :name,
                ],
              },
            },
          }
        end

        # 出題用
        def article_json_struct_for_show
          {
            only: [
              :id,              # 必要
              :key,
              :position,
              :init_sfen,
              :viewpoint,
              :title,
              :description,
              :direction_message,
              :turn_max,
              :difficulty,
            ],
            methods: [
              :folder_key,
            ],
            include: {
              moves_answers: {
                only: [
                  :id,
                  # :moves_str,
                  :moves_human_str,
                ],
                methods: [
                  :moves,
                ],
              },
            },
          }
        end

        def json_struct_for_article_edit_form
          {
            only: [
              :id,
              :key,
              :title,
            ],
            methods: [
              :folder_key,
            ],
            include: {
              folder: {
                only: [
                  :key,
                  :id,
                  :name,
                ],
              },
            },
          }
        end
      end
    end
  end
end
