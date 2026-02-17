require "./setup"

module Wkbk
  class KifuDataImport
    attr_accessor :params

    def initialize(params = {})
      @params = params
    end

    def call
      user = User.admin

      # Wkbk.destroy_all
      # Wkbk.setup

      # user.wkbk_articles.destroy_all
      # user.wkbk_books.destroy_all

      dir = Rails.root.join("kifu_data").expand_path
      dir.glob("*").sort.each do |book_dir|
        book_title = book_dir.basename(".*").to_s
        puts book_title

        if book = user.wkbk_books.find_by(title: book_title)
          book.dependent_records_destroy_all
          book.destroy!
        end

        book = user.wkbk_books.create!(title: book_title, folder_key: :private, sequence_key: :bookship_position_asc)

        book_dir.glob("*.kif").sort.take(1000).each do |file|
          str = file.read.strip
          next if str.empty?
          puts file

          begin
            info = Bioshogi::Parser.parse(str)
            str = info.to_sfen                    # => "position sfen 5g2l/4g1ks1/4ppn1p/6pP1/7R1/9/9/9/9 b Brb2g3s3n3l13p 1 moves B*2c 2b2c 2d2c+ 3b3a 2c3c", "position sfen 5g2l/4g1ks1/4ppn1p/6pP1/7R1/9/9/9/9 b Brb2g3s3n3l13p 1 moves B*2c 3b4b 2e2h"
            sfen = Bioshogi::Sfen.parse(str)
            parts = file.basename(".*").to_s.split("_")   # => ["07", "1"], ["07", "2"]
            title = book_title + " " + parts[0]           # => "雑に攻める 07", "雑に攻める 07"
            init_sfen = sfen.board_and_b_or_w_and_piece_box_and_turn
            moves_str = sfen.moves.join(" ")
          rescue => error
            puts error
            next
          end

          if article = user.wkbk_articles.find_by(init_sfen: init_sfen)
            article.moves_answers.create!(moves_str: moves_str)
          else
            article = user.wkbk_articles.build(init_sfen: init_sfen)
            article.lineage_key = "手筋"
            article.title = title
            article.folder_key = :private
            article.save!
            article.moves_answers.create!(moves_str: moves_str)
            book.articles << article
          end
        end
      end
    end
  end
end

Wkbk::KifuDataImport.new.call
tp Wkbk.info

# >> 雑に攻める
# >> /Users/ikeda/src/shogi/shogi-extend/kifu_data/雑に攻める/07_1.kif
# >> /Users/ikeda/src/shogi/shogi-extend/kifu_data/雑に攻める/07_2.kif
# >> |-------------------+-------+--------|
# >> | model             | count | 最終ID |
# >> |-------------------+-------+--------|
# >> | User              |     1 |      1 |
# >> | Wkbk::Bookship    |     1 |    137 |
# >> | Wkbk::Article     |     1 |    116 |
# >> | Wkbk::MovesAnswer |     2 |    126 |
# >> | Wkbk::Book        |     1 |    104 |
# >> | Wkbk::Lineage     |     8 |     40 |
# >> | Wkbk::Folder      |     3 |     15 |
# >> |-------------------+-------+--------|
