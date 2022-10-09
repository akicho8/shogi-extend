require "rails_helper"

RSpec.describe KifuMailAdapter, type: :model, swars_spec: true do
  it do
    object = KifuMailAdapter.new({
        :sfen   => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
        :turn   => 0,
        :title  => "(title)",
        :url    => "http://localhost:3000/share-board?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1&turn=0&abstract_viewpoint=black", :format=>"json", :controller=>"api/share_boards", :action=>"remote_notify2", :share_board=>{"sfen"=>"position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1", "turn"=>0, "title"=>"共有将棋盤", "url"=>"http://localhost:3000/share-board?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1&turn=0&abstract_viewpoint=black"},
        :black  => "(black)",
        :white  => "(white)",
        :other  => "(other)",
        :member => "(member)",
      })
    puts object.body
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
