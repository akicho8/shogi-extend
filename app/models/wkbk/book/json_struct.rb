module Wkbk
  class Book
    concern :JsonStruct do
      class_methods do
        def json_struct_for_top
          {
            only: [
              # :id,
              :key,
              :title,
              # :description,
              :bookships_count,
              # :created_at,
              :updated_at,
            ],
            methods: [
              :folder_key,
              # :sequence_key,
              # :tweet_body,
              :avatar_path,
              :bookships_count_by_current_user,
            ],
            include: {
              user: {
                only: [
                  # :key,
                  :id,
                  :name,
                ],
                methods: [
                  :avatar_path,
                ],
              },
              # folder: {
              #   only: [
              #     :key,
              #     :id,
              #     :name,
              #   ],
              # },
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
            ],
            methods: [
              :folder_key,
              :sequence_key,
              :tweet_body,
              :raw_avatar_path,
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
                      # :id,
                      :key,
                      # :position,
                      :title,
                      :difficulty,
                      :turn_max,
                      :created_at,
                      :updated_at,
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
            ],
            methods: [
              :folder_key,
              :sequence_key,
              :tweet_body,
              :og_meta,
              :avatar_path,
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
              :id,
              :key,
              :position,
              :init_sfen,
              :title,
              :description,
              :direction_message,
              :turn_max,
            ],
            methods: [
              :folder_key,
              # :lineage_key,
            ],
            include: {
              moves_answers: {
                only: [
                  :moves_str,
                ],
              },
            },
          }
        end

        def json_struct_for_article_edit
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
