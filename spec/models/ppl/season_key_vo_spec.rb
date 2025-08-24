require "rails_helper"

RSpec.describe Ppl::SeasonKeyVo, type: :model do
  it "spider" do
    assert { Ppl::SeasonKeyVo["S49"].spider_class == Ppl::AntiquitySpider }
    assert { Ppl::SeasonKeyVo["30"].spider_class  == Ppl::MedievalSpider  }
    assert { Ppl::SeasonKeyVo["31"].spider_class  == Ppl::ModernitySpider }
  end

  it ".start" do
    assert { Ppl::SeasonKeyVo.start.to_s == "S49" }
  end

  it ".succ" do
    assert { Ppl::SeasonKeyVo["S62"].succ == Ppl::SeasonKeyVo["1"] }
    assert { Ppl::SeasonKeyVo["30"].succ == Ppl::SeasonKeyVo["31"] }
  end
end
