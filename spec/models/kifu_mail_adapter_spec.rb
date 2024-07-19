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
# >> 1999-12-31T15:00:00.000Z pid=68377 tid=1k7x INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> ▼再生
# >> http://localhost:3000/u/1CpQBEFuW6
# >> 
# >> ▼*再生URLの元
# >> http://localhost:4000/share-board?black=%28black%29&member=%28member%29&other=%28other%29&title=%28title%29&turn=2&viewpoint=white&white=%28white%29&xbody=cG9zaXRpb24gc2ZlbiBsbnNna2dzbmwvMXI1YjEvcHBwcHBwcHBwLzkvOS85L1BQUFBQUFBQUC8xQjVSMS9MTlNHS0dTTkwgYiAtIDEgbW92ZXMgNmk1aCA0YTViIDRpNGggNmE2Yg
# >> 
# >> ▼*KENTO
# >> https://www.kento-shogi.com/?initpos=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&moves=6i5h.4a5b.4i4h.6a6b
# >> 
# >> ▼*KENTO (ShortUrl)
# >> http://localhost:3000/u/JQpQxuYPjzt
# >> 
# >> ▼棋譜
# >> 先手の備考：居飛車, 相居飛車, 対居飛車
# >> 後手の備考：居飛車, 相居飛車, 対居飛車
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
# >> http://localhost:3000/share-board?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1.moves.6i5h.4a5b.4i4h.6a6b&turn=4&viewpoint=black
# >> 
# >> ▼*share_board_url (ShortUrl)
# >> http://localhost:3000/u/sAjs4L8YS2t
# >> 
# >> ▼*piyo_url
# >> piyoshogi://?viewpoint=black&num=4&url=http://localhost:3000/share-board.kif?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1.moves.6i5h.4a5b.4i4h.6a6b&turn=4&viewpoint=black
# >> 
# >> ▼*piyo_url (ShortUrl)
# >> http://localhost:3000/u/08KiyE0eV2v
# >> 
# >> ▼*kento_url
# >> https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&viewpoint=black&moves=6i5h.4a5b.4i4h.6a6b#4
# >> 
# >> ▼*kento_url (ShortUrl)
# >> http://localhost:3000/u/bLStQdObWOs
# >>   works
# >> 
# >> Top 1 slowest examples (0.84858 seconds, 28.7% of total time):
# >>   KifuMailAdapter works
# >>     0.84858 seconds -:4
# >> 
# >> Finished in 2.96 seconds (files took 2.09 seconds to load)
# >> 1 example, 0 failures
# >> 
