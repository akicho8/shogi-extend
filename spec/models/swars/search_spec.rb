require "rails_helper"

module Swars
  RSpec.describe type: :model, swars_spec: true do
    before do
      Swars.setup
    end

    describe "手合割" do
      def case1(value)
        black = User.create!
        white = User.create!
        users = [black, white]
        csa_seq = SwarsMedalSupport.csa_seq_generate1(1)
        Battle.create_with_members!(users, preset_key: "平手", csa_seq: csa_seq)
        Battle.create_with_members!(users, preset_key: "角落ち", csa_seq: csa_seq)
        Battle.create_with_members!(users, preset_key: "飛車落ち", csa_seq: csa_seq)
        query_info = QueryInfo.parse("手合割:#{value}")
        scope = Battle.search(current_swars_user: white, query_info: query_info)
        scope.collect { |e| e.preset_key }
      end

      it "works" do
        assert { case1("平手")              == ["平手"]               }
        assert { case1("!平手")             == ["角落ち", "飛車落ち"] }
        assert { case1("-平手")             == ["角落ち", "飛車落ち"] }
        assert { case1("角落ち")            == ["角落ち"]             }
        assert { case1("角落ち,飛車落ち")   == ["角落ち", "飛車落ち"] }
        assert { case1("-角落ち,-飛車落ち") == ["平手"] }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> {:type=>:model, :swars_spec=>true}
# >>   手合割
# >>     works
# >> 
# >> Top 1 slowest examples (3.47 seconds, 66.0% of total time):
# >>   {:type=>:model, :swars_spec=>true} 手合割 works
# >>     3.47 seconds -:23
# >> 
# >> Finished in 5.26 seconds (files took 4.01 seconds to load)
# >> 1 example, 0 failures
# >> 
