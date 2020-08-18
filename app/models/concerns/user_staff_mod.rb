module UserStaffMod
  extend ActiveSupport::Concern

  class_methods do
    # rails r "tp User.sysop"
    def sysop
      staff_user_factory(key: "sysop", name: "運営", email: AppConfig[:admin_email])
    end

    def bot
      staff_user_factory(key: "bot", name: "BOT", email: AppConfig[:bot_email], race_key: :robot)
    end

    def staff_user_factory(attributes)
      key = attributes[:key]
      if user = find_by(key: key)
        return user
      end
      user = create!(attributes.merge(password: Rails.application.credentials.sysop_password))

      user.permit_tag_list = "staff"
      user.save!

      user
    end
  end

  def sysop?
    key == "sysop"
  end

  def bot?
    key == "bot"
  end
end
