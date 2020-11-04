module Emox
  concern :MessageShared do
    included do
      cattr_accessor(:body_max_length) { 512 }

      cattr_accessor(:json_struct_type8) do
        {
          only: [:id, :body, :created_at],
          include: {
            user: {
              only: [:id, :key, :name],
              methods: [:avatar_path],
            },
          },
        }
      end

      belongs_to :user, class_name: "::User"

      before_validation do
        if will_save_change_to_attribute?(:body) && body.present?
          self.body = double_blank_lines_to_one_line(body)
          self.body = body.strip
          self.body = script_tag_escape(body)

          # 先頭が "*" で始まるデバッグ用のメッセージはエラーになると困るのでちょんぎる
          # としようと思ったけどいろいろ面倒なので常にちょんぎることにする
          if true || body.start_with?("*")
            self.body = body.first(body_max_length)
          end
        end
      end

      with_options presence: true do
        validates :body
      end

      with_options allow_blank: true do |o|
        o.validates :body, length: { maximum: body_max_length }
      end
    end

    def as_json_type8
      as_json(json_struct_type8)
    end

    def unescaped_body
      CGI.unescapeHTML(body)
    end
  end
end
