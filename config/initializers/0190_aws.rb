aws = Rails.application.credentials[:aws]
credentials = Aws::Credentials.new(aws[:access_key_id], aws[:secret_key])
Aws.config.update(region: "us-west-2", credentials: credentials)

# tp Aws.config
