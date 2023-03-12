# https://github.com/alexrudall/ruby-openai
OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.fetch(:chatgpt_api_key)
end
