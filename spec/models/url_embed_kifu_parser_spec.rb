require "rails_helper"

RSpec.describe UrlEmbedKifuParser, type: :model do
  it do
    sfen = UrlEmbedKifuParser.parse("https://www.kento-shogi.com/?moves=5g5f.8c8d.7g7f.8d8e.8h7g.6a5b.2h5h.7a6b.7i6h.5a4b.6h5g.4b3b.5i4h.1c1d.1g1f.6c6d.5f5e.6b6c.5g5f.3a4b.4h3h.4c4d.3h2h.4b4c.3i3h.7c7d.9g9f.9c9d.9i9g.3c3d.4g4f.2b3c.5h9h.8e8f.8g8f.8b8d.6i5h.3b2b.9f9e.9d9e.9g9e.P%2A9d.9e9d.9a9d.P%2A9e.7d7e.7f7e.3c2d.5h4g.4a3b.9e9d.5c5d.L%2A8e.5d5e.5f5e.P%2A7f.7g9i.8d8e.8f8e.2d3c.4f4e.L%2A8f.5e4d.4c4d.9i4d.8f8i%2B.S%2A4a.S%2A4c.4a3b%2B.4c3b.9d9c%2B.3c4d.4e4d.L%2A4e.4d4c%2B.4e4g%2B.4c3b.2b3b.3h4g.7f7g%2B.9c8c.B%2A6e.9h9b%2B.6e4g%2B.L%2A4h.P%2A4f.4h4g.4f4g%2B.P%2A4h.S%2A5h.4i3i.L%2A3h.3i3h.4g3h.2h3h.S%2A1g.B%2A5d.G%2A4c.5d4c%2B.3b4c.L%2A4f.N%2A4d.2i1g.B%2A5g.S%2A5e.G%2A5d.R%2A4a.4c3c.5e4d#34")
    assert { sfen == "position startpos moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g8f 8b8d 6i5h 3b2b 9f9e 9d9e 9g9e P*9d 9e9d 9a9d P*9e 7d7e 7f7e 3c2d 5h4g 4a3b 9e9d 5c5d L*8e 5d5e 5f5e P*7f 7g9i 8d8e 8f8e 2d3c 4f4e L*8f 5e4d 4c4d 9i4d 8f8i+ S*4a S*4c 4a3b+ 4c3b 9d9c+ 3c4d 4e4d L*4e 4d4c+ 4e4g+ 4c3b 2b3b 3h4g 7f7g+ 9c8c B*6e 9h9b+ 6e4g+ L*4h P*4f 4h4g 4f4g+ P*4h S*5h 4i3i L*3h 3i3h 4g3h 2h3h S*1g B*5d G*4c 5d4c+ 3b4c L*4f N*4d 2i1g B*5g S*5e G*5d R*4a 4c3c 5e4d" }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.60663 seconds (files took 2.15 seconds to load)
# >> 1 example, 0 failures
# >> 
