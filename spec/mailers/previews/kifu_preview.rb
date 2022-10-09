# http://localhost:3000/rails/mailers/kifu

class KifuPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/kifu/basic_mail
  def basic_mail
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
    params = params.merge(user: User.first)
    KifuMailer.basic_mail(params)
  end
end
