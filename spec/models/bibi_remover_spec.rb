require 'rails_helper'

RSpec.describe BibiRemover do
  it "works" do
    str = [8234, 102, 111, 111, 8236].pack("U*")
    assert { BibiRemover.execute(str).codepoints == [102, 111, 111] }
  end
end
