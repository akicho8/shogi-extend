require "rails_helper"

RSpec.describe "default_url_options" do
  it "works" do
    assert { Rails.configuration.action_mailer.default_url_options == { host: "localhost", port: 3000 } }
    assert { Rails.application.routes.default_url_options == { host: "localhost", port: 3000 } }
  end
end
