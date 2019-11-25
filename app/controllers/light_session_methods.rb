module LightSessionMethods
  extend ActiveSupport::Concern

  included do
    helper_method :talk
  end

  let :custom_session_id do
    Digest::MD5.hexdigest(session.id || SecureRandom.hex) # Rails.env.test? のとき session.id がないんだが
  end

  # talk("こんにちは")
  #
  # 実行順序
  #
  #   light_session_channel.rb
  #     light_session_app.js
  #       vue_support.js (talk)
  #         axios
  #           talk_controller.rb
  #         Audio#play
  #
  # ショートカットする方法
  #
  #   ActionCable.server.broadcast("light_session_channel_#{custom_session_id}", talk: Talk.new(source_text: "こんにちは").as_json)
  #
  def talk(message, **options)
    light_session_channel_command(:talk, options.merge(message: message))
  end

  def direct_talk(message, **options)
    talk = Talk.new(source_text: message)
    light_session_channel_command(:direct_talk, options.merge(talk: talk))
  end

  def sound_play(key, **options)
    light_session_channel_command(:sound_play, options.merge(key: key))
  end

  def toast_message(message, **options)
    options = {
      position: "is-bottom",
    }.merge(options)

    light_session_channel_command(:toast_message, options.merge(message: message))
  end

  private

  # broadcast だけど購読者は本人のみ
  def light_session_channel_command(command, options)
    ActionCable.server.broadcast(light_session_channel_key, options.merge(command: command))
  end

  def light_session_channel_key
    "light_session_channel_#{custom_session_id}"
  end
end
