require "rails_helper"

module Wkbk
  RSpec.describe BookArchive, type: :model do
    include WkbkSupportMethods
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    it "works" do
      user = User.create!
      book = user.wkbk_books.create!(title: "(book)")
      article = user.wkbk_articles.create!(title: "(article)", init_sfen: "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1")
      article.moves_answers.create!(moves_str: "G*5b")
      book.articles << article

      book_archive = BookArchive.new(book: book, current_user: User.create!)

      Zip::InputStream.open(book_archive.to_zip) do |zis|
        entry = zis.get_next_entry
        assert { entry.name == "_book_/001__article_/1.kif" }
      end
    end
  end
end
