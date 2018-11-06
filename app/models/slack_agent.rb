module SlackAgent
  extend self

  def chat_post_message(key:, body:)
    if Rails.env.production? || Rails.env.development?
      Slack::Web::Client.new.tap do |client|
        client.chat_postMessage(channel: "#exception", text: "【#{key}】#{body}")
      end
    end
  end
end
