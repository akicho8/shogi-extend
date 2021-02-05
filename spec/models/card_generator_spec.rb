require 'rails_helper'

RSpec.describe CardGenerator, type: :model do
  it "works" do
    CardGenerator.to_blob(base_color: [0, 0.5, 0.5], index: 0, font_luminance: 0.98, stroke_darker: 0.05, stroke_width: 4)
  end
end
