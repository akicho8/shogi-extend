require "rails_helper"

module QuickScript
  RSpec.describe Chore::IndexScript, type: :model do
    it "works" do
      assert { Chore::IndexScript.new.call }
    end

    it "指定のグループで絞る" do
      Chore::IndexScript.new(qs_group_only: "dev").all.all? { |e| e.qs_group_info.key == :dev }
    end

    it "指定のグループで絞っているときタイトルはそのグループになる" do
      assert { Chore::IndexScript.new.title == "Index" }
      assert { Chore::IndexScript.new(qs_group_only: "dev").title == "*開発用*" }
    end

    it "qs_invisible を有効にしているスクリプトは見えないが「*」で検索すると見える" do
      assert { Chore::IndexScript.new(query: " ").all.include?(Dev::InvisibleScript) == false }
      assert { Chore::IndexScript.new(query: "*").all.include?(Dev::InvisibleScript) == true  }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> QuickScript::Chore::IndexScript
# >>   works
# >>   qs_invisible
# >>
# >> Top 2 slowest examples (0.21992 seconds, 9.6% of total time):
# >>   QuickScript::Chore::IndexScript works
# >>     0.16729 seconds -:5
# >>   QuickScript::Chore::IndexScript qs_invisible
# >>     0.05263 seconds -:9
# >>
# >> Finished in 2.3 seconds (files took 2.1 seconds to load)
# >> 2 examples, 0 failures
# >>
