require "rails_helper"

module QuickScript
  RSpec.describe Dispatcher, type: :model do
    it "実行した結果を返す" do
      assert { Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "null") }
    end

    it "バックグラウンド実行用" do
      action = Dispatcher.background_dispatch({qs_group_key: "dev", qs_page_key: "null"}, {current_user_id: User.create!.id})
      assert { action.current_user }
    end

    it "OGPの情報のみを返す" do
      assert { Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "null", __RESPOND_TO_CRAWLER__: true) }
    end

    it "対応するクラスが反応している" do
      assert { Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "null").class == Dev::NullScript }
    end

    it "対応するクラスがない場合" do
      assert { Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "xxx").class == Chore::NotFoundScript }
    end

    it "ページの指定がない場合は一覧に委譲する" do
      assert { Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "__qs_page_key_is_blank__").class == Chore::IndexScript }
    end

    it "ハイフンとアンダーバーの差異を吸収する" do
      assert { Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "foo-bar-baz").class == Dev::FooBarBazScript }
      assert { Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "foo_bar_baz").class == Dev::FooBarBazScript }
    end

    it "info" do
      assert { Dispatcher.info }
    end
  end
end

