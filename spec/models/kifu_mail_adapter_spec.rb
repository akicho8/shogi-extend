require "rails_helper"

RSpec.describe KifuMailAdapter, type: :model, swars_spec: true do
  it do
    params = {
      :source => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 6i5h 4a5b 4i4h 6a6b",
      :turn   => 2,
      :title  => "(title)",
      :black  => "(black)",
      :white  => "(white)",
      :other  => "(other)",
      :member => "(member)",
      :app_urls => {
        :share_board_url => "http://localhost:3000/share-board?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1.moves.6i5h.4a5b.4i4h.6a6b&turn=4&abstract_viewpoint=black",
        :piyo_url        => "piyoshogi://?viewpoint=black&num=4&url=http://localhost:3000/share-board.kif?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1.moves.6i5h.4a5b.4i4h.6a6b&turn=4&abstract_viewpoint=black",
        :kento_url       => "https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&viewpoint=black&moves=6i5h.4a5b.4i4h.6a6b#4",
      },
    }
    object = KifuMailAdapter.new(params)
    assert { object.subject }
    assert { object.body }
    assert { object.attachment_filename }
    assert { object.attachment_body }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> KifuMailAdapter
# >> ▼再生用URL
# >> http://localhost:3000/share-board?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1&turn=0&abstract_viewpoint=black
# >> 
# >> ▼棋譜
# >> 棋戦：(title)
# >> 先手の備考：居飛車, 相居飛車
# >> 後手の備考：居飛車, 相居飛車
# >> 先手：(black)
# >> 後手：(white)
# >> 観戦：(other)
# >> 面子：(member)
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 投了
# >> まで0手で後手の勝ち
# >>   example at -:4
# >> 
# >> Top 1 slowest examples (0.16921 seconds, 11.3% of total time):
# >>   KifuMailAdapter 
# >>     0.16921 seconds -:4
# >> 
# >> Finished in 1.5 seconds (files took 6.23 seconds to load)
# >> 1 example, 0 failures
# >> 
