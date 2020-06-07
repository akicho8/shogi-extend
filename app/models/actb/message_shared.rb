module Actb
  concern :MessageShared do
    included do
      belongs_to :user, class_name: "::User"

      before_validation do
        if changes_to_save[:body] && body.present?
          self.body = body.gsub(/\R{3,}/, "\n\n")
          self.body = body.strip
          self.body = Loofah.fragment(body).scrub!(:escape).to_s
        end

        # ちょんぎる
        if changes_to_save[:body] && body
          self.body = body.to_s.first(self.class.columns_hash["body"].limit)
        end
      end

      with_options presence: true do
        validates :body
      end

      if table_exists?
        validates :body, length: { maximum: columns_hash["body"].limit }
      end
    end
  end
end
