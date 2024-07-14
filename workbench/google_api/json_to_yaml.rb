require "./setup"
GoogleApi::JsonToYaml.new.call

Rails.application.credentials.dig(:google_api, :development).to_s.size # => 2369
Rails.application.credentials.dig(:google_api, :test).to_s.size        # => 2369
Rails.application.credentials.dig(:google_api, :production).to_s.size  # => 2342
Rails.application.credentials.dig(:google_api, :staging).to_s.size     # => 2342

tp Rails.application.credentials.dig(:google_api, :development)
tp Rails.application.credentials.dig(:google_api, :test)
tp Rails.application.credentials.dig(:google_api, :production)
tp Rails.application.credentials.dig(:google_api, :staging)
