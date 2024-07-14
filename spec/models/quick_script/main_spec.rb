require "rails_helper"

module QuickScript
  RSpec.describe Main, type: :model do
    it "klass_fetch" do
      assert { Main.klass_fetch(qs_group_key: "dev", qs_page_key: "null") == Dev::NullScript }
    end

    it "グループ内のリストを返す" do
      Main.dispatch(qs_group_key: "dev", qs_page_key: "__qs_page_key_is_blank__")
    end

    it "基本形" do
      Main.dispatch(qs_group_key: "dev", qs_page_key: "null")
    end

    it "OGP用の情報のみを返す" do
      Main.dispatch(qs_group_key: "dev", qs_page_key: "null", __FOR_ASYNC_DATA__: true)
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> QuickScript::Main
# >>   klass_fetch
# >>   グループ内のリストを返す
# >>   基本形
# >>   OGP用の情報のみを返す
# >> 
# >> Top 4 slowest examples (0.31756 seconds, 13.4% of total time):
# >>   QuickScript::Main klass_fetch
# >>     0.14253 seconds -:5
# >>   QuickScript::Main グループ内のリストを返す
# >>     0.06815 seconds -:9
# >>   QuickScript::Main 基本形
# >>     0.05356 seconds -:13
# >>   QuickScript::Main OGP用の情報のみを返す
# >>     0.05333 seconds -:17
# >> 
# >> Finished in 2.37 seconds (files took 2.09 seconds to load)
# >> 4 examples, 0 failures
# >> 
