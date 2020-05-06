RSpec::Rails::ControllerExampleGroup.module_eval do
  concerning :ColosseumMethods do
    included do
      before do
      end
      after do
      end
    end

    def user_login(attributes = {})
      create(:colosseum_user, attributes).tap do |user|
        user_logout
        controller.current_user_set(user)
      end
    end

    def user_logout
      controller.current_user_clear
    end
  end
end
