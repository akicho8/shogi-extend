RSpec::Rails::ControllerExampleGroup.module_eval do
  concerning :ColosseumMethods do
    included do
      before do
      end
      after do
      end
    end

    def user_login(attributes = {})
      case attributes
      when User
        user_logout
        controller.current_user_set(attributes)
      when Hash
        create(:user, attributes).tap do |user|
          user_logout
          controller.current_user_set(user)
        end
      end
    end

    def user_logout
      controller.current_user_clear
    end
  end
end
