require 'rails_helper'

RSpec.describe Talk do
  it "as_json" do
    Timecop.return do
      talk = Talk.new(source_text: "こんにちは")
      assert { talk.as_json }
    end
  end

  it "キャッシュOFFで生成" do
    Timecop.return do
      talk = Talk.new(source_text: "こんにちは", cache_enable: false)
      assert { talk.as_json }
    end
  end

  it "cache_delete" do
    talk = Talk.new(source_text: "こんにちは")
    talk.cache_delete
  end

  it "normalized_text" do
    talk = Talk.new(source_text: "A<b>B</b>C > D <br><br/>")
    assert { talk.normalized_text == "ABC D" }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ....
# >> 
# >> Finished in 4.54 seconds (files took 2.18 seconds to load)
# >> 4 examples, 0 failures
# >> 
