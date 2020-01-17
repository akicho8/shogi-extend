require 'rails_helper'

module Swars
  RSpec.describe Agent, type: :model do
    before do
      @agent = Agent.new
    end

    it "index_get" do
      assert { @agent.index_get(gtype: "",  user_key: "devuser1", page_index: 0)   }
      assert { @agent.index_get(gtype: "sb",  user_key: "devuser1", page_index: 0) }
    end

    it "record_get" do
      assert { @agent.record_get("myasuMan-chrono_-20200116_232605")               }
      assert { @agent.record_get("kkkkkfff-kinakom0chi-20191229_211058")           }
    end
  end
end
