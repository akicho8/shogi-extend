require "rails_helper"

RSpec.describe Ppl::SeasonKeyVo, type: :model do
  it "spider" do
    assert { Ppl::SeasonKeyVo["S49"].spider_klass == Ppl::AntiquitySpider }
    assert { Ppl::SeasonKeyVo["30"].spider_klass  == Ppl::MedievalSpider  }
    assert { Ppl::SeasonKeyVo["31"].spider_klass  == Ppl::ModernitySpider }
  end

  it ".start" do
    assert { Ppl::SeasonKeyVo.start.to_s == "S49" }
  end
end
