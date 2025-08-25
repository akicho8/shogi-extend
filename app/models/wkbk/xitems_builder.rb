# http://localhost:3000/api/wkbk/books/show.json?book_key=6&_user_id=1
# rails r "User.admin.wkbk_answer_logs.destroy_all"
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

      if !Book.article_json_struct_for_show[:only].include?(:id)
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
            :spent_sec_total => nil,
            # :ox_rate          => v.o_count.fdiv(v.o_count + v.x_count),
            # :last_answered_at => v.last_answered_at.to_time,
          },
          :newest_answer_log => {
            :answer_kind_key => nil,
            :spent_sec       => nil,
            :created_at      => nil,
          },
        }
      end

      private_article_blank_write
      answer_stat_embet
      newest_answer_log_embed

      @xitems
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
    def answer_log_stat_records
      MysqlToolkit.mysql_convert_tz_with_time_zone_validate!
      correct_count = "COUNT(answer_kind_id = #{AnswerKind.correct.id} OR NULL) AS correct_count"
      mistake_count = "COUNT(answer_kind_id = #{AnswerKind.mistake.id} OR NULL) AS mistake_count"
      spent_sec_total = "SUM(spent_sec) AS spent_sec_total"
      select = "article_id, #{correct_count}, #{mistake_count}, #{spent_sec_total}, MAX(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS last_answered_at"
      answer_logs.select(select).group("article_id")
    end

    private

    # ログインしていれば正解率を入れる
    def answer_stat_embet
      if current_user
        @xitems.each do |e|
          list = answer_log_stat_records
          hash = list.index_by(&:article_id)
          if v = hash[e[:article]["id"]]
            a = e[:answer_stat]
            a[:correct_count] = v.correct_count
            a[:mistake_count] = v.mistake_count
            a[:spent_sec_total] = v.spent_sec_total
            # :ox_rate          => v.o_count.fdiv(v.o_count + v.x_count),
            # :last_answered_at => v.last_answered_at.to_time,
          end
        end
      end
    end

    # current_user が見れない問題は無理矢理隠す
    # 最初から除外するのではなく見えないデータを返す (Youtubeの仕様を参考)
    def private_article_blank_write
      if book.user != current_user
        @xitems.each do |xitem|
          e = xitem[:article]
          if e["folder_key"] == "private"
            e["init_sfen"]         = nil
            e["title"]             = nil
            e["description"]       = nil
            e["direction_message"] = nil
            e["turn_max"]          = nil
            e["moves_answers"]     = nil
          end
        end
      end
    end

    # 最後の解答の情報を埋める
    def newest_answer_log_embed
      if current_user
        @xitems.each do |e|
          article_id = e[:article]["id"]
          if exist_article_ids.include?(article_id) # ←これはなくてもいいけどSQLをスキップしたいので入れている
            if v = answer_logs.where(article_id: article_id).order(created_at: :desc).take
              e[:newest_answer_log] = {
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
