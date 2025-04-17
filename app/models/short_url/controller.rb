# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Component (short_url_components as ShortUrl::Component)
#
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | name              | desc              | type         | opts                | refs | index |
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | id                | ID                | integer(8)   | NOT NULL PK         |      |       |
# | key               | キー              | string(255)  | NOT NULL            |      | A!    |
# | original_url      | Original url      | string(2048) | NOT NULL            |      |       |
# | access_logs_count | Access logs count | integer(4)   | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時          | datetime     | NOT NULL            |      |       |
# | updated_at        | 更新日時          | datetime     | NOT NULL            |      |       |
# |-------------------+-------------------+--------------+---------------------+------+-------|

module ShortUrl
  module Controller
    extend self

    # コントローラー用
    # 作成 curl http://localhost:3000/api/short_url/components.json -d "original_url=/"
    # 移動 curl -I http://localhost:3000/u/UaswCQacfXi.html
    #
    # 注意:
    #   curl -I http://localhost:3000/u/UaswCQacfXi
    #   とした場合は request.format.json? が有効になるのはなぜ？
    #
    def show_action(c)
      record = Component.fetch(c.params)
      record.access_logs.create!        # アクセスログは本当にリダイレクトする直前に記録する
      c.redirect_to record.original_url # allow_other_host: true としていないので外部サイトには飛べない
    end

    def create_action(c)
      c.render json: Component[c.params[:original_url]]
    end
  end
end
