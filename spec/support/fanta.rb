RSpec::Rails::ControllerExampleGroup.module_eval do
  concerning :FantaMethods do
    included do
      before do
      end
      after do
      end
    end

    def user_login
      create(:fanta_user).tap do |user|
        user_logout
        session[:user_id] = user.id
      end
    end

    def user_logout
      @controller.instance_variable_set(:@current_user, nil)
      session[:user_id] = nil
    end
  end
end
