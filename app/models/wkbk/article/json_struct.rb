module Wkbk
  class Article
    concern :JsonStruct do
      class_methods do
        # 一覧
        def json_struct_for_index
          {
            only: [
              :id,
              :key,
              :position,
              :init_sfen,
              :viewpoint,
              :title,
              :description,
              :tag_list,
              :direction_message,
              :difficulty,
              :turn_max,
              :mate_skip,
              :moves_answers_count,
              :created_at,
              :updated_at,
            ],
            methods: [
              :folder_key,
              :lineage_key,
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
              books: {
                only: [
                  :key,
                  :title,
                ],
                methods: [
                  :folder_key,
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
              :position,
              :init_sfen,
              :viewpoint,
              :title,
              :description,
              :tag_list,
              :direction_message,
              :difficulty,
              :turn_max,
              :mate_skip,
              :moves_answers_count,
              # :created_at,
              # :updated_at,
            ],
            methods: [
              :book_keys,
              :folder_key,
              :lineage_key,
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
              moves_answers: {},
              books: {
                only: [
                  :key,
                  :title,
                ],
                methods: [
                  :folder_key,
                ],
              },
            },
          }
        end

        def json_struct_for_show
          {
            only: [
              :id,
              :key,
              :book_keys,
              :position,
              :init_sfen,
              :viewpoint,
              :title,
              :description,
              :tag_list,
              :direction_message,
              :difficulty,
              :turn_max,
              :mate_skip,
              :moves_answers_count,
              :created_at,
              :updated_at,
            ],
            methods: [
              :book_keys,
              :folder_key,
              :lineage_key,
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
              lineage: {
                only: [
                  :id,
                  :key,
                ],
                methods: [
                  :name,
                ],
              },
              moves_answers: {},
              books: {
                only: [
                  :key,
                  :title,
                  :bookships_count,
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
              },
            },
          }
        end
      end
    end
  end
end
