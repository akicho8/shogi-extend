# for slack-ruby-client gem
# https://api.slack.com/apps/ADUGJCCFJ/oauth?success=1
# rails credentials:edit
Slack.configure do |config|
  config.token = Rails.application.credentials[:slack_api_token]
end
