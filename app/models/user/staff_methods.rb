class User
  module StaffMethods
    extend ActiveSupport::Concern

    class_methods do
      # rails r "tp User.admin"
      # rails r "tp User.admin.permit_tag_list"
      def admin
        staff_create!(key: "admin", name: "運営", email: AppConfig[:admin_email])
      end

      def bot
        staff_create!(key: "bot", name: "BOT", email: AppConfig[:bot_email], race_key: :robot)
      end

      def staff_create!(attrs)
        key = attrs[:key]
        if user = find_by(key: key)
          return user
        end

        create!(attrs) do |e|
          e.password = Rails.application.credentials.staff_password
          e.confirmed_at = Time.current
          e.permit_tag_list = "staff"
          e.name_input_at = Time.current
        end
      end
    end

    def admin?
      key == "admin"
    end

    def bot?
      key == "bot"
    end

    def staff?
      permit_tag_list.include?("staff")
    end

    # def ban?
    #   permit_tag_list.include?("ban")
    # end
  end
end
