require "rails_helper"

RSpec.describe DiffCop, type: :model do
  it do
    text_old = <<~EOT
    aaa
    ccc
    EOT

    text_new = <<~EOT
    aaa
    bbb
    ccc
    EOT

    DiffCop.new(text_old, text_new).to_s.should == <<~EOT
    + bbb
    EOT
  end
end
