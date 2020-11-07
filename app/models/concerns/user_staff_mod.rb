module UserStaffMod
  extend ActiveSupport::Concern

  class_methods do
    # rails r "tp User.sysop"
    # rails r "tp User.sysop.permit_tag_list"
    def sysop
      staff_create!(key: "sysop", name: "運営", email: AppConfig[:admin_email])
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
        e.password = Rails.application.credentials.sysop_password
        e.confirmed_at = Time.current
        e.permit_tag_list = "staff"
        e.name_input_at = Time.current
      end
    end
  end

  def sysop?
    key == "sysop"
  end

  def bot?
    key == "bot"
  end
end
