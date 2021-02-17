module WkbkSupportMethods
  extend ActiveSupport::Concern

  included do
    before(:context) do
      Actb.setup
      Emox.setup
      Wkbk.setup
      Wkbk::Book.mock_setup
    end

    let(:user1) { User.create!(name: "user1", email: "user1@localhost", confirmed_at: Time.current) }
    let(:user2) { User.create!(name: "user2", email: "user2@localhost", confirmed_at: Time.current) }
    let(:user3) { User.create!(name: "user3", email: "user3@localhost", confirmed_at: Time.current) }

    let(:article1) do
      user1.wkbk_articles.create_mock1
    end
  end
end

RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :WkbkMethods do
  end
end
