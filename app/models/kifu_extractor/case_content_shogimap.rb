# rails r 'puts KifuExtractor.extract(%(<shogi-board header="true" black="先手" white="後手" kif="position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 8c8d 5g5f 3c3d 5f5e" board="paper" viewpoint="black" turn="5" ki2="▲７六歩△８四歩▲５六歩△３四歩▲５五歩"></shogi-board>))'
module KifuExtractor
  class CaseContentShogimap < Base
    def resolve

      if md = item.source.match(/(?<qm>["'])(?<body>position\s+sfen\s+.*?)\k<qm>/)
        @body = md[:body]
      end
    end
  end
end
