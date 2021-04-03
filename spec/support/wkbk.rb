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

    before do
      @__wkbk_config__ = Wkbk::Config.clone
      Wkbk::Config.update({
          :black_piece_zero_check_on_function_enable => true, # 「詰将棋」なら先手の駒が余っていないことを確認するか？
          :mate_validate_on_function_enable          => true, # 「詰将棋」か「持駒限定詰将棋」か「実戦詰め筋」なら詰んでいることを確認
        })
    end

    after do
      Wkbk::Config.update(@__wkbk_config__)
    end
  end
end

RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :WkbkMethods do
  end
end
