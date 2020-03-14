require 'rails_helper'

module Swars
  RSpec.describe Battle::Membership, type: :model do
    before do
      Swars.setup
    end

    describe "タグ" do
      let :record do
        Battle.create!
      end
      it do
        assert { record.memberships[0].attack_tag_list  == ["嬉野流"]           }
        assert { record.memberships[1].attack_tag_list  == ["△３ニ飛戦法"]     }
        assert { record.memberships[0].defense_tag_list == []                   }
        assert { record.memberships[1].defense_tag_list == []                   }
        assert { record.memberships[0].note_tag_list    == ["居飛車", "居玉"]   }
        assert { record.memberships[1].note_tag_list    == ["振り飛車", "居玉"] }
      end
    end
  end
end
