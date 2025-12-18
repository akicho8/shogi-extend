require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit("/share-board?body=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL%20b%20%201%20moves%202g2f%203c3d%207g7f%204c4d%206g6f%203a4b%202f2e%204b3c%204i5h%204a3b%206i7h%208c8d%207i6h%207a6b%203i4h%206a5b%205i6i%205c5d%206h6g%202b3a%205g5f%208d8e%204h5g%205a6a%205f5e%205d5e%206f6e%208e8f%208g8f%203a8f%208h6f%208f3a%20P%2a8g%206b5c%208i7g%206a5a%203g3f%205c5d%205g4f%205a4a%203f3e%203d3e%204f3e%205b4c%202e2d%203c2d%203e2d%202c2d%202h2d%20P%2a2c%202d2f%201c1d%201g1f%20P%2a8f%208g8f%208b8f%20P%2a8g%208f8b%202i3g%20S%2a3e%202f2e%204c3d%202e2i%20P%2a3f%203g2e%202c2d%20P%2a3c%202a3c%202e3c%2B%203d3c")
    assert_text("入力のSFEN形式が不正確です")
  end
end
