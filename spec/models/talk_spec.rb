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
end
