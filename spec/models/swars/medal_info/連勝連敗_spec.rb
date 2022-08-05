require "rails_helper"

module Swars
  RSpec.describe "連勝連敗", type: :model, swars_spec: true do
    let(:user) { User.create! }

    def case1(judge_key, count = 1)
      count.times do
        Battle.create! do |e|
          e.memberships.build(user: user, judge_key: judge_key)
        end
      end
      user.user_info.medal_list.matched_medal_infos.collect(&:name)
    end

    it "連勝" do
      assert { case1(:win).exclude?("5連勝")  }
      assert { case1(:win).exclude?("5連勝")  }
      assert { case1(:win).exclude?("5連勝")  }
      assert { case1(:win).exclude?("5連勝")  }
      assert { case1(:win).include?("5連勝")  }
      assert { case1(:win).include?("5連勝")  }
      assert { case1(:win).include?("5連勝")  }
      assert { case1(:win).include?("5連勝")  }
      assert { case1(:win).include?("5連勝")  }
      assert { case1(:win).include?("10連勝") }
    end

    it "連敗" do
      assert { case1(:lose).exclude?("5連敗")  }
      assert { case1(:lose).exclude?("5連敗")  }
      assert { case1(:lose).exclude?("5連敗")  }
      assert { case1(:lose).exclude?("5連敗")  }
      assert { case1(:lose).include?("5連敗")  }
      assert { case1(:lose).include?("5連敗")  }
      assert { case1(:lose).include?("5連敗")  }
      assert { case1(:lose).include?("5連敗")  }
      assert { case1(:lose).include?("5連敗")  }
      assert { case1(:lose).include?("10連敗") }
    end

    it "波が激しいマン" do
      assert { case1(:win,  5).exclude?("波が激しいマン") }
      assert { case1(:lose, 5).include?("波が激しいマン") }
    end
  end
end
