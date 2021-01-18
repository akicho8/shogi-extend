module WbookSupportMethods
  extend ActiveSupport::Concern

  included do
    before(:context) do
      Wbook.setup
      Emox.setup
    end

    let(:user1) { User.create!(name: "user1", email: "user1@localhost", confirmed_at: Time.current) }
    let(:user2) { User.create!(name: "user2", email: "user2@localhost", confirmed_at: Time.current) }
    let(:user3) { User.create!(name: "user3", email: "user3@localhost", confirmed_at: Time.current) }

    let(:question1) do
      user1.wbook_questions.create_mock1
    end

    let(:question_message1) do
      question1.messages.create!(user: user2, body: "(body)")
    end

    let(:notification1) do
      user1.notifications.create!(question_message: question_message1)
    end

    let(:room1) do
      Wbook::Room.create_with_members!([user1, user2])
    end

    let(:battle1) do
      room1.battle_create_with_members!
    end
  end
end

RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :WbookMethods do
  end
end
