# http://0.0.0.0:3000/api/wkbk/books/show.json?book_key=6&_user_id=1
#
# {
#   config: {
#     api_articles_fetch_per: 5,
#     api_books_fetch_per: 5
#   },
#   book: {
#     id: 6,
#     key: "6",
#     title: "sysopの解答履歴付き",
#     description: "(description)",
#     bookships_count: 3,
#     created_at: "2021-02-14T22:44:17.252+09:00",
#     updated_at: "2021-02-14T22:44:17.485+09:00",
#     folder_key: "public",
#     sequence_key: "bookship_position_asc",
#     tweet_body: "sysopの解答履歴付き #インスタント将棋問題集 http://0.0.0.0:4000/rack/books/6",
#     og_meta: {
#       title: "sysopの解答履歴付き - bob",
#       description: "(description)",
#       og_image: "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--8fc2fc8294a9a1980c77265b96adb6cac15641e8/e4f70b36906d181493856942939e0857.png"
#     },
#     avatar_path: "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--8fc2fc8294a9a1980c77265b96adb6cac15641e8/e4f70b36906d181493856942939e0857.png",
#     tag_list: [ ],
#     user: {
#       id: 4,
#       key: "76c333487c607bc3c574f954c4ba9802",
#       name: "bob",
#       avatar_path: "/assets/human/0002_fallback_avatar_icon-4db2be582c579b81375c3d64ed3581bea717063226098ab5ac8131d5fe18b5bf.png"
#     },
#     folder: {
#       id: 1,
#       key: "public"
#     },
#     xitems: [
#       {
#         index: 0,
#         bookship: {
#           created_at: "2021-02-14T22:44:17.425+09:00"
#         },
#         article: {
#           id: 8,
#           key: "6-1",
#           init_sfen: "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1",
#           title: "ox",
#           description: "",
#           direction_message: "",
#           turn_max: 0,
#           folder_key: "public",
#           moves_answers: [ ]
#         },
#         answer_stat: {
#           o_count: 1,
#           x_count: 1,
#           ox_rate: 0.5,
#           last_answered_at: "2021-02-14T22:44:17.000+09:00"
#         },
#         latest_answer_log: {
#           answer_kind_key: "mistake",
#           spent_sec: 2,
#           created_at: "2021-02-14T22:44:17.000+09:00"
#         }
#       },
#       {
#         index: 1,
#         bookship: {
#           created_at: "2021-02-14T22:44:17.456+09:00"
#         },
#         article: {
#           id: 9,
#           key: "6-2",
#           init_sfen: "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1",
#           title: "o",
#           description: "",
#           direction_message: "",
#           turn_max: 0,
#           folder_key: "public",
#           moves_answers: [ ]
#         },
#         answer_stat: {
#           o_count: 0,
#           x_count: 1,
#           ox_rate: 0,
#           last_answered_at: "2021-02-14T22:44:17.000+09:00"
#         },
#         latest_answer_log: {
#           answer_kind_key: "mistake",
#           spent_sec: 3,
#           created_at: "2021-02-14T22:44:17.000+09:00"
#         }
#       },
#       {
#         index: 2,
#         bookship: {
#           created_at: "2021-02-14T22:44:17.480+09:00"
#         },
#         article: {
#           id: 10,
#           key: "6-3",
#           init_sfen: "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1",
#           title: "初",
#           description: "",
#           direction_message: "",
#           turn_max: 0,
#           folder_key: "public",
#           moves_answers: [ ]
#         }
#       }
#     ]
#   }
# }
#
module Wkbk
  class XitemsBuilder
    attr_accessor :params

    def initialize(params, options = {}, &block)
      @params = params
      @options = {
        excludes_from_scratch_that_current_user_can_not_access: false # current_user がアクセスできないものは最初から除外する
      }.merge(options)
      if block_given?
        yield self
      end
    end

    def to_a
      s = book.bookships
      if @options[:excludes_from_scratch_that_current_user_can_not_access]
        s = bookships.access_restriction_by(current_user)
      end
      s = book.sequence.pure_info.apply[s] # これは最後でもいい？
      s = s.joins(:article).includes(article: :moves_answers)

      unless Book.article_json_struct_for_show[:only].include?(:id)
        raise "must not happen"
      end

      @xitems = s.collect.with_index do |e, i| # ここでSQL発生
        {
          :index      => i,
          :bookship   => {
            created_at: e.created_at, # 追加日
          },
          :article    => e.article.as_json(Book.article_json_struct_for_show),
          :answer_stat => {
            :correct_count => 0,
            :mistake_count => 0,
            # :ox_rate          => v.o_count.fdiv(v.o_count + v.x_count),
            # :last_answered_at => v.last_answered_at.to_time,
          },
          :latest_answer_log => {
            :answer_kind_key => nil,
            :spent_sec       => nil,
            :created_at      => nil,
          },
        }
      end

      private_article_blank_write
      answer_stat_embet
      latest_answer_log_embed

      @xitems
    end

    private

    # ログインしていれば正解率を入れる
    def answer_stat_embet
      if current_user
        @xitems.each do |e|
          hash = answer_logs_hash
          if v = hash[e[:article]["id"]]
            a = e[:answer_stat]
            a[:correct_count] = v.correct_count
            a[:mistake_count] = v.mistake_count
            # :ox_rate          => v.o_count.fdiv(v.o_count + v.x_count),
            # :last_answered_at => v.last_answered_at.to_time,
          end
        end
      end
    end

    # これが引けるので article_id をキーにしたハッシュにして返す
    #
    #  +------------+---------------------------+---------+---------|
    #  | article_id | last_answered_at          | o_count | x_count |
    #  +------------+---------------------------+---------+---------|
    #  |        503 | 2000-01-01 00:00:00 +0900 |       2 |       1 |
    #  |        504 | 2000-01-01 00:00:00 +0900 |       0 |       1 |
    #  +------------+---------------------------+---------+---------|
    #
    def answer_logs_hash
      DbCop.mysql_convert_tz_with_time_zone_validate!
      correct_count = "COUNT(answer_kind_id = #{AnswerKind.correct.id} OR NULL) AS correct_count"
      mistake_count = "COUNT(answer_kind_id = #{AnswerKind.mistake.id} OR NULL) AS mistake_count"
      select = "article_id, #{correct_count}, #{mistake_count}, MAX(#{DbCop.tz_adjust(:created_at)}) AS last_answered_at"
      records = answer_logs.select(select).group("article_id")
      records.inject({}) { |a, e| a.merge(e.article_id => e) }
    end

    # current_user が見れない問題は無理矢理隠す
    # 最初から除外するのではなく見えないデータを返す (Youtubeの仕様を参考)
    def private_article_blank_write
      if book.user != current_user
        @xitems.each do |xitem|
          e = xitem[:article]
          if e["folder_key"] == "private"
            e["init_sfen"]         = ""
            e["title"]             = "非公開"
            e["description"]       = ""
            e["direction_message"] = ""
            e["turn_max"]          = 0
            e["moves_answers"]     = []
          end
        end
      end
    end

    # 最後の解答の情報を埋める
    def latest_answer_log_embed
      if current_user
        @xitems.each do |e|
          article_id = e[:article]["id"]
          if exist_article_ids.include?(article_id) # ←これはなくてもいいけどSQLをスキップしたいので入れている
            if v = answer_logs.where(article_id: article_id).order(created_at: :desc).take
              e[:latest_answer_log] = {
                :answer_kind_key => v.answer_kind.key,
                :spent_sec       => v.spent_sec,
                :created_at      => v.created_at,
              }
            end
          end
        end
      end
    end

    # 一度でも解いた問題たちのIDs
    # ものすごい数になりそうに思えるが book のスコープがあるので問題ない
    def exist_article_ids
      @exist_article_ids ||= answer_logs.distinct.pluck(:article_id).to_set # 問題数はそれほどないので全部取得してOK
    end

    # current_user が book で解答した結果たち
    # book を指定することでかなり絞れる
    def answer_logs
      current_user.wkbk_answer_logs.where(book: book)
    end

    # 対象の問題集
    def book
      params[:book]
    end

    # 自分
    def current_user
      params[:current_user]
    end
  end
end
