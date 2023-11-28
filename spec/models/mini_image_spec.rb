require "rails_helper"

RSpec.describe MiniImage, type: :model do
  it "デフォルト画像" do
    assert { MiniImage.generate == "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEUAAP+KeNJXAAAACklEQVQI12NgAAAAAgAB4iG8MwAAAABJRU5ErkJggg==" }
  end

  it "カスタマイズ" do
    assert { MiniImage.generate(width: 1, height: 1, color: "red", format: :jpg).match?(%{data:image/jpeg;base64,/9j/.*}) }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> MiniImage
# >>   デフォルト画像
# >>   カスタマイズ
# >> 
# >> Top 2 slowest examples (0.1291 seconds, 10.8% of total time):
# >>   MiniImage デフォルト画像
# >>     0.08162 seconds -:4
# >>   MiniImage カスタマイズ
# >>     0.04748 seconds -:8
# >> 
# >> Finished in 1.2 seconds (files took 0.95782 seconds to load)
# >> 2 examples, 0 failures
# >> 
