require "rails_helper"

RSpec.describe ShareBoard::SenderInfo do
  it "bot" do
    assert { ShareBoard::SenderInfo[:bot] }
    assert { ShareBoard::SenderInfo[:bot].default_options_fn.call }
  end
  it "admin" do
    assert { ShareBoard::SenderInfo[:admin] }
    assert { ShareBoard::SenderInfo[:admin].default_options_fn.call }
  end
end
