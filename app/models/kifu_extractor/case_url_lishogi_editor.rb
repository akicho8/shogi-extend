# lishogi editor
# rails r 'puts KifuExtractor.extract("https://lishogi.org/editor/ln5nl/2kp3R1/2l4p1/p1pg1+BP1p/9/PPP1PP3/1SN5P/1KG1G2+r1/L8_w_G2Pb3sn4p_1")'
module KifuExtractor
  class CaseUrlLishogiEditor < Extractor
    def resolve
      if uri = extracted_uri
        if uri.to_s.include?("lishogi.org/editor")
          # uri.path # => "/editor/ln5nl/2kp3R1/2l4p1/p1pg1+BP1p/9/PPP1PP3/1SN5P/1KG1G2+r1/L8_w_G2Pb3sn4p_1"
          if md = uri.path.match(%{editor/(?<dirty_sfen>.*)})
            s = md[:dirty_sfen]      # => "ln5nl/2kp3R1/2l4p1/p1pg1+BP1p/9/PPP1PP3/1SN5P/1KG1G2+r1/L8_w_G2Pb3sn4p_1"
            s = s.gsub(/_/, " ")     # => "ln5nl/2kp3R1/2l4p1/p1pg1+BP1p/9/PPP1PP3/1SN5P/1KG1G2+r1/L8 w G2Pb3sn4p 1"
            s = "position sfen #{s}" # => "position sfen ln5nl/2kp3R1/2l4p1/p1pg1+BP1p/9/PPP1PP3/1SN5P/1KG1G2+r1/L8 w G2Pb3sn4p 1"
            @body = s
          end
        end
      end
    end
  end
end
