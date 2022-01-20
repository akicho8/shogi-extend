require "rails_helper"

module Wkbk
  RSpec.describe Sequence, type: :model do
    include WkbkSupportMethods

    describe "並び替え" do
      describe "タイトルを" do
        def test1(titles, sequence_key)
          user = User.create!
          book = user.wkbk_books.create!(sequence_key: sequence_key)
          titles.each do |e|
            book.articles << user.wkbk_articles.create!(title: e)
          end
          xitems_builder = XitemsBuilder.new(current_user: user, book: book)
          av = xitems_builder.to_a
          av.collect { |e| e[:article]["title"] }
        end
        describe "文字列として" do
          it "昇順" do
            assert { test1(%w(1 10 2), :article_title_asc)  === %w(1 10 2) }
          end
          it "降順" do
            assert { test1(%w(1 10 2), :article_title_desc) === %w(2 10 1) }
          end
        end
        describe "数値として" do
          it "昇順" do
            assert { test1(%w(1 10 2), :article_title_number_asc)  === %w(1 2 10) }
          end
          it "降順" do
            assert { test1(%w(1 10 2), :article_title_number_desc) === %w(10 2 1) }
          end
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Wkbk::Sequence
# >>   並び替え
# >>     タイトルを
# >>       文字列として
# >>         昇順
# >>         降順
# >>       数値として
# >>         昇順
# >>         降順
# >> 
# >> Top 4 slowest examples (2.69 seconds, 29.9% of total time):
# >>   Wkbk::Sequence 並び替え タイトルを 文字列として 昇順
# >>     0.80149 seconds -:20
# >>   Wkbk::Sequence 並び替え タイトルを 数値として 降順
# >>     0.66457 seconds -:31
# >>   Wkbk::Sequence 並び替え タイトルを 文字列として 降順
# >>     0.61392 seconds -:23
# >>   Wkbk::Sequence 並び替え タイトルを 数値として 昇順
# >>     0.60883 seconds -:28
# >> 
# >> Finished in 8.99 seconds (files took 4.16 seconds to load)
# >> 4 examples, 0 failures
# >> 
