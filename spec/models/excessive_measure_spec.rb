require "rails_helper"

RSpec.describe ExcessiveMeasure, type: :model do
  it "works" do
    excessive_measure = ExcessiveMeasure.new
    assert { excessive_measure.wait_value_for_job == 0 }
    assert { excessive_measure.wait_value_for_job == 0 } # キャッシュが効いてないので仕方ない
  end
end
