require "rails_helper"

module QuickScript
  RSpec.describe Parameter, type: :model do
    it "対応するクラスを返す" do
      parameter = QuickScript::Parameter.new(qs_group_key: "dev", qs_page_key: "foo-bar-baz")
      assert { parameter.receiver_klass == QuickScript::Dev::FooBarBazScript }
    end

    it "qs_page_key がない場合" do
      parameter = QuickScript::Parameter.new(qs_group_key: "dev", qs_page_key: "__qs_page_key_is_blank__")
      assert { parameter.receiver_klass == QuickScript::Chore::IndexScript }
    end
  end
end
