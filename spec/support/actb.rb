module ActbSupportMethods
  extend ActiveSupport::Concern

  included do
    before(:context) do
      Actb.setup
    end

    let_it_be(:user1) { User.create! }
    let_it_be(:user2) { User.create! }

    let(:question1) do
      user1.actb_questions.mock_type1
    end

    let_it_be(:room1) do
      Actb::Room.create_with_members!([user1, user2], rule: Actb::Rule.fetch(:marathon_rule))
    end

    let_it_be(:battle1) do
      room1.battle_create_with_members!
    end
  end
end

RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :ActbMethods do
  end
end
