require "rails_helper"

RSpec.describe StandardDeviation do
  it "works" do
    av = [
      { "度数" => 1 },
      { "度数" => 2 },
      { "度数" => 4 },
      { "度数" => 2 },
      { "度数" => 1 },
    ]
    av = StandardDeviation.call(av)
    assert { av[2]["偏差値"] == 50 }
  end
end
