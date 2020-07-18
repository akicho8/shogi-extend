module Actb
  concern :MessageShared do
    included do
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
          self.body = body.gsub(/\R{3,}/, "\n\n")
          self.body = body.strip
          self.body = Loofah.fragment(body).scrub!(:escape).to_s
        end

        # ちょんぎる
        if will_save_change_to_attribute?(:body) && body
          self.body = body.to_s.first(self.class.columns_hash["body"].limit)
        end
      end

      with_options presence: true do
        validates :body
      end

      begin
        if table_exists?
          validates :body, length: { maximum: columns_hash["body"].limit }
        end
      rescue ActiveRecord::StatementInvalid => error
        p ["#{__FILE__}:#{__LINE__}", __method__, error]
      end

      # begin
      #   validates :body, length: { maximum: columns_hash["body"].limit }
      # rescue Mysql2::Error
      # end
    end

    def as_json_type8
      as_json(json_struct_type8)
    end

    def unescaped_body
      CGI.unescapeHTML(body)
    end
  end
end
