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

    # let(:article_message1) do
    #   article1.messages.create!(user: user2, body: "(body)")
    # end
    #
    # let(:notification1) do
    #   user1.notifications.create!(article_message: article_message1)
    # end
    #
    # let(:room1) do
    #   Wkbk::Room.create_with_members!([user1, user2])
    # end
    #
    # let(:battle1) do
    #   room1.battle_create_with_members!
    # end
  end
end

RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :WkbkMethods do
  end
end
