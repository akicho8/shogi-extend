# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Sequence (wkbk_sequences as Wkbk::Sequence)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | position   | 順序     | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

require "rails_helper"

RSpec.describe Wkbk::Sequence, type: :model do
  include WkbkSupportMethods

  describe "並び替え" do
    describe "タイトルを" do
      def case1(titles, sequence_key)
        user = User.create!
        book = user.wkbk_books.create!(sequence_key: sequence_key)
        titles.each do |e|
          book.articles << user.wkbk_articles.create!(title: e)
        end
        xitems_builder = Wkbk::XitemsBuilder.new(current_user: user, book: book)
        av = xitems_builder.to_a
        av.collect { |e| e[:article]["title"] }
      end
      describe "文字列として" do
        it "昇順" do
          assert { case1(%w(1 10 2), :article_title_asc)  === %w(1 10 2) }
        end
        it "降順" do
          assert { case1(%w(1 10 2), :article_title_desc) === %w(2 10 1) }
        end
      end
      describe "数値として" do
        it "昇順" do
          assert { case1(%w(1 10 2), :article_title_number_asc)  === %w(1 2 10) }
        end
        it "降順" do
          assert { case1(%w(1 10 2), :article_title_number_desc) === %w(10 2 1) }
        end
      end
    end
  end
end
