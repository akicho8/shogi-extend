module ActbSupportMethods
  extend ActiveSupport::Concern

  included do
    before(:context) do
      Actb.setup
    end

    let(:user1) { User.create!(name: "user1", email: "user1@localhost") }
    let(:user2) { User.create!(name: "user2", email: "user2@localhost") }
    let(:user3) { User.create!(name: "user3", email: "user3@localhost") }

    let(:question1) do
      user1.actb_questions.mock_type1
    end

    let(:room1) do
      Actb::Room.create_with_members!([user1, user2], rule: Actb::Rule.fetch(:marathon_rule))
    end

    let(:battle1) do
      room1.battle_create_with_members!
    end
  end
end

RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :ActbMethods do
  end
end
