require "rails_helper"

RSpec.describe KifuMailAdapter, type: :model do
  it "works" do
    object = KifuMailAdapter.new(KifuMailAdapter.mock_params)
    assert { object.subject == "(title) 棋譜" }
    assert { object.body }
    assert { object.attachment_filename == "20000101000000_title.kif" }
    assert { object.attachment_body }
    assert { object.mail_to_address }
    puts object.body if $0 == __FILE__
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> KifuMailAdapter
# >> ▼再生
# >> https://tinyurl.com/2lkn3lly
# >>
# >> ▼*再生URLの元
# >> http://localhost:4000/share-board?abstract_viewpoint=white&black=%28black%29&member=%28member%29&other=%28other%29&title=%28title%29&turn=2&white=%28white%29&xbody=cG9zaXRpb24gc2ZlbiBsbnNna2dzbmwvMXI1YjEvcHBwcHBwcHBwLzkvOS85L1BQUFBQUFBQUC8xQjVSMS9MTlNHS0dTTkwgYiAtIDEgbW92ZXMgNmk1aCA0YTViIDRpNGggNmE2Yg
# >>
# >> ▼*KENTO
# >> https://www.kento-shogi.com/?initpos=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&moves=6i5h.4a5b.4i4h.6a6b
# >>
# >> ▼*KENTO (TinyUrl)
# >> https://tinyurl.com/2q6ptks8
# >>
# >> ▼棋譜
# >> 先手の備考：居飛車, 相居飛車
# >> 後手の備考：居飛車, 相居飛車
# >> 棋戦：(title)
# >> 先手：(black)
# >> 後手：(white)
# >> 観戦：(other)
# >> 面子：(member)
# >> 手合割：平手
# >>
# >> ▲５八金左 △５二金左 ▲４八金上 △６二金上
# >> まで4手で後手の勝ち
# >>
# >> ▼*share_board_url
# >> http://localhost:3000/share-board?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1.moves.6i5h.4a5b.4i4h.6a6b&turn=4&abstract_viewpoint=black
# >>
# >> ▼*share_board_url (TinyUrl)
# >> https://tinyurl.com/2gy4qmre
# >>
# >> ▼*piyo_url
# >> piyoshogi://?viewpoint=black&num=4&url=http://localhost:3000/share-board.kif?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1.moves.6i5h.4a5b.4i4h.6a6b&turn=4&abstract_viewpoint=black
# >>
# >> ▼*piyo_url (TinyUrl)
# >> https://tinyurl.com/2e74fddc
# >>
# >> ▼*kento_url
# >> https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&viewpoint=black&moves=6i5h.4a5b.4i4h.6a6b#4
# >>
# >> ▼*kento_url (TinyUrl)
# >> https://tinyurl.com/2hg58w8o
# >>   works
# >>
# >> Top 1 slowest examples (2.66 seconds, 62.5% of total time):
# >>   KifuMailAdapter works
# >>     2.66 seconds -:4
# >>
# >> Finished in 4.25 seconds (files took 6.97 seconds to load)
# >> 1 example, 0 failures
# >>
