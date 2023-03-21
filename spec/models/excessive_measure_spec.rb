require "rails_helper"

RSpec.describe ExcessiveMeasure, type: :model do
  it "works" do
    excessive_measure = ExcessiveMeasure.new
    is_asserted_by { excessive_measure.wait_value_for_job == 0 }
    is_asserted_by { excessive_measure.wait_value_for_job == 0 } # キャッシュが効いてないので仕方ない
  end
end
