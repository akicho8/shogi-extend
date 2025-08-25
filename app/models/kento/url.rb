# frozen-string-literal: true

# object = Kento::Url["https://example.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6"]
# tp object.attributes            # => {initpos: "ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1", branch_from: 0, branch: ["N*7e", "7d7e", "B*7d", "8c9c", "G*9b", "9a9b", "7d9b+", "9c9b", "6c7b", "R*8b", "G*8c", "9b9a", "7b8b", "7c8b", "R*9b"], moves: nil}
# object.to_sfen                  # => "position sfen ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1"
# # >> |-------------+---------------------------------------------------------------------------------------------------------------------------|
# # >> |     initpos | ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1                                                           |
# # >> | branch_from | 0                                                                                                                         |
# # >> |      branch | ["N*7e", "7d7e", "B*7d", "8c9c", "G*9b", "9a9b", "7d9b+", "9c9b", "6c7b", "R*8b", "G*8c", "9b9a", "7b8b", "7c8b", "R*9b"] |
# # >> |       moves |                                                                                                                           |
# # >> |-------------+---------------------------------------------------------------------------------------------------------------------------|
#
# https://www.kento-shogi.com/?moves=5g5f.8c8d.7g7f.8d8e.8h7g.6a5b.2h5h.7a6b.7i6h.5a4b.6h5g.4b3b.5i4h.1c1d.1g1f.6c6d.5f5e.6b6c.5g5f.3a4b.4h3h.4c4d.3h2h.4b4c.3i3h.7c7d.9g9f.9c9d.9i9g.3c3d.4g4f.2b3c.5h9h.8e8f.8g8f.8b8d.6i5h.3b2b.9f9e.9d9e.9g9e.P%2A9d.9e9d.9a9d.P%2A9e.7d7e.7f7e.3c2d.5h4g.4a3b.9e9d.5c5d.L%2A8e.5d5e.5f5e.P%2A7f.7g9i.8d8e.8f8e.2d3c.4f4e.L%2A8f.5e4d.4c4d.9i4d.8f8i%2B.S%2A4a.S%2A4c.4a3b%2B.4c3b.9d9c%2B.3c4d.4e4d.L%2A4e.4d4c%2B.4e4g%2B.4c3b.2b3b.3h4g.7f7g%2B.9c8c.B%2A6e.9h9b%2B.6e4g%2B.L%2A4h.P%2A4f.4h4g.4f4g%2B.P%2A4h.S%2A5h.4i3i.L%2A3h.3i3h.4g3h.2h3h.S%2A1g.B%2A5d.G%2A4c.5d4c%2B.3b4c.L%2A4f.N%2A4d.2i1g.B%2A5g.S%2A5e.G%2A5d.R%2A4a.4c3c.5e4d#34
# https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F9%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%201&moves=7a6b.7g7f.5c5d.2g2f.6b5c.3i4h.4a3b.4i5h.6c6d.5i6h.7c7d.7i7h.5a6b.2f2e.6b6c.7h7g.6a6b.7g6f.8a7c.9g9f.9c9d.7f7e.6d6e.6f7g.7d7e.7g8f.5c6d.5g5f.3a4b.4h5g.4b5c.5g4f.8c8d.6g6f.7e7f.2e2d.2c2d.2h2d.P%2A2c.2d2e.8d8e.8f9g.6e6f.8h6f.4c4d.8g8f.3c3d.8f8e.2a3c.2e2h.7f7g%2B.8i7g.P%2A7f.9g8f.7f7g%2B.8f7g.6d6e.6f4h.P%2A8f.P%2A6f.6e5f.P%2A5g.4d4e.5g5f.4e4f.4g4f.8f8g%2B.7g7f.N%2A6d.7f7e.6d5f.6h5g.5f4h%2B.5g4h.8g7g.P%2A7d.7c8e.P%2A2d.2c2d.2h2d.P%2A2c.2d2h.P%2A4e.4f4e.P%2A4f.S%2A4d.3c4e.4d5c%2B.6c5c.P%2A2d.B%2A5f.S%2A3f.S%2A4g.3f4g.S%2A5g.5h5g.4e5g%2B.4h3h.4f4g%2B.3h2g.4g3h.2h3h.5f3h%2B.2g3h.R%2A4h.3h2g.S%2A3h.2g1f.4h4f%2B.S%2A3f.1c1d.S%2A2f.G%2A1e.2f1e.1d1e#115
# https://www.kento-shogi.com/?branch=6i7h.8c8d&branchFrom=2&moves=3i4h.3c3d.5g5f.7a6b.4h5g.5c5d.2g2f.6b5c.2f2e.2b3c.1g1f.3a2b.9g9f.9c9d.1f1e.8c8d.6i7h.8d8e.5i6i.8e8f.8g8f.8b8f.P%2A8g.8f8b.4i5h.5a6b.6g6f.4a5b.5h6g.6b7b.7g7f.5b6b.8h7g.7c7d.7i8h.6b7c.8g8f.8b8c.8h8g.7b8b.6i7i.6a7b.3g3f.5c6d.5g4f.5d5e.5f5e.6d5e.4f5e.3c5e.2h5h.P%2A5d.S%2A4f.5e4f.4g4f.S%2A5e.6f6e.S%2A4g.5h2h.2b3c.B%2A3b.4g5f%2B.6g5f.5e5f.3b2a%2B.3c4d.2a4c.4d5e.4c5d.5e4f.7g1a%2B.4f5g%2B.P%2A5i.5f6g%2B.S%2A6i.P%2A5h.5i5h.G%2A6h.6i6h.6g5h.6h5g.5h5g.P%2A5h.5g5f.L%2A5g.S%2A6g.5g5f.6g5f%2B.5d4e.P%2A5e.N%2A6h.L%2A8d.6h5f.5e5f.4e5f.8d8f.8g8f.8c8f.L%2A8g.8f8g%2B.7h8g.L%2A8c.P%2A8f.P%2A5e.1a5e.9d9e.9f9e.S%2A8d.R%2A4b.8d9e.9i9e.9a9e.P%2A9g.L%2A8d.S%2A6a.6c6d.6a7b%2B.7c7b.5e6d.S%2A7c.6d7c.8a7c.G%2A9b.8b9b.4b7b%2B.9b9c.S%2A8b.9c9d.G%2A9c#2
#
module Kento
  class Url
    class << self
      def [](...)
        new(...)
      end

      def parse(...)
        new(...)
      end
    end

    private_class_method :new

    attr_accessor :url

    def initialize(url)
      @url = url
      @cache = {}
      freeze
    end

    def to_sfen
      components = ["position"]

      if initpos
        components += ["sfen", initpos]
      else
        components += ["startpos"]
      end

      if branch_from && branch && moves
        m = moves.take(branch_from) + branch
      else
        m = moves
      end

      if m.presence
        components += ["moves", *m]
      end

      components * " "
    end

    def attr_names
      [:initpos, :branch_from, :branch, :moves]
    end

    def attributes
      @cache[:attributes] ||= attr_names.index_with { send(it) }
    end

    def info
      attributes
    end

    def to_h
      attributes
    end

    private

    def initpos
      lookup(:initpos)
    end

    def branch_from
      lookup(:branchFrom).try { to_i }
    end

    def branch
      lookup(:branch).try { split(".") }
    end

    def moves
      lookup(:moves).try { split(".") }
    end

    def lookup(key)
      query[key].presence
    end

    def query
      @cache[:query] ||= Rack::Utils.parse_query(uri.query).symbolize_keys
    end

    def uri
      @cache[:uri] ||= URI(url)
    end
  end
end
