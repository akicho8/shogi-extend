module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def __event_notify__(method_name, params = {})
      return if Rails.env.production? || Rails.env.test?

      body = []
      body << "[#{Time.current.to_s(:ymdhms)}]"
      if current_user
        body << "[#{current_user.id}][#{current_user.name}]"
      end
      body << " "
      body << params.inspect

      SlackAgent.message_send(key: "#{self.class.name}##{method_name}", body: body.join)
    end
  end
end
