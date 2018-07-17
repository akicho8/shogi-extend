RSpec::Rails::ControllerExampleGroup.module_eval do
  concerning :ColosseumMethods do
    included do
      before do
      end
      after do
      end
    end

    def user_login
      create(:colosseum_user).tap do |user|
        user_logout
        controller.current_user_set_id(user.id)
      end
    end

    def user_logout
      controller.current_user_logout
    end
  end
end
