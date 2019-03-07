module SlackAgent
  extend self

  def chat_post_message(key:, body:)
    if Rails.env.test?
      return
    end

    if ENV["SETUP"]
      return
    end

    Slack::Web::Client.new.tap do |client|
      client.chat_postMessage(channel: "#shogi_web", text: "【#{key}】#{body}")
    end
  end
end
