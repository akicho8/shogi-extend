# 将棋トレーニングバトル
#
# entry
#   app/models/frontend_script/actb_app_script.rb
#
# vue
#   app/javascript/actb_app/index.vue
#
# db
#   db/migrate/20200505135600_create_actb.rb
#
# test
#   experiment/0860_actb.rb
#
# model
#   app/models/actb/membership.rb
#   app/models/actb/battle.rb
#   app/models/actb.rb
#   app/models/colosseum/user_actb_mod.rb
#
#   question
#     app/models/actb/question.rb
#     app/models/actb/moves_answer.rb
#
# channel
#   app/channels/actb/lobby_channel.rb
#   app/channels/actb/battle_channel.rb
#
# job
#   app/jobs/actb/lobby_broadcast_job.rb
#   app/jobs/actb/message_broadcast_job.rb
#
module FrontendScript
  class ActbAppScript < ::FrontendScript::Base
    # FIXME: GET, PUT で分けるのではなく関心で分離する
    include GetApi
    include PutApi

    include DebugMod

    self.script_name = "将棋トレーニングバトル"
    self.page_title = ""
    self.form_position = :bottom
    self.column_wrapper_enable = false

    if Rails.env.production?
      self.visibility_hidden = true
    end

    delegate :current_user, to: :h

    def script_body
      if v = params[:remote_action]
        return public_send(v)
      end

      # JS 側からいきなりログイン画面に飛ばすとどこに戻ればよいかわからない
      # なのでいったんここに飛ばして return_to を設定させてログイン画面に飛ぶ
      if params[:goto_login]
        h.session[:return_to] = h.url_for(:tb)
        c.redirect_to :new_xuser_session
        return
      end

      ################################################################################

      info = {}
      info[:config] = Actb::Config
      info[:mode] ||= "lobby"   # FIXME: とる
      info[:api_path] = h.url_for(script_link_path)
      info[:question_default] = question_default
      if current_user
        info[:current_user] = current_user_json

        if true
          # すでにログインしている人は x-cable で unauthorized になる
          # これはクッキーに記録しないままログインしたのが原因
          # なのですでにログインしていたらクッキーに埋める
          c.current_user_set_for_action_cable(current_user)
        end
      end

      debug_scene_params_set(info)

      if request.format.json?
        return info
      end

      ################################################################################

      c.layout_type = :raw

      out = ""
      out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
      out += %(<div id="app"><actb_app :info='#{info.to_json}' /></div>)
      out
    end

    def put_action
      c.render json: public_send(params[:remote_action])
    end

    def current_battle_id
      params[:battle_id].presence
    end

    def current_battle
      if v = current_battle_id
        Actb::Battle.find_by(id: v)
      end
    end

    # リアクティブになるように空でもカラムは作っておくこと
    def question_default
      default = {
        :title               => nil,
        :description         => nil,
        :hint_desc           => nil,
        :time_limit_sec      => 10.seconds,
        :moves_answers       => [],
        :init_sfen           => "position sfen 4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1",

        :difficulty_level    => 1,
        :lineage             => { key: "詰将棋" },
        :folder_key          => "active",

        # 他者が作者
        :other_author        => nil,
        :source_media_name   => nil,
        :source_media_url    => nil,
        :source_published_on => nil,
      }

      if Rails.env.development?
        default.update({
            :title            => "(title)",
            :time_limit_sec   => 30.seconds,
            :init_sfen => "position sfen 7gk/9/7GG/7N1/9/9/9/9/9 b 2r2bg4s3n4l18p 1",
            :moves_answers => [
              :moves_str => "1c1b",
              :end_sfen  => "7gk/8G/7G1/7N1/9/9/9/9/9 w 2r2bg4s3n4l18p 2",
            ],
          })
      end

      default
    end

    def current_user_json
      current_user.as_json(only: [:id, :key, :name], methods: [:avatar_path, :rating, :skill_key, :description])
    end

    def users
      [current_user, User.bot]
    end

    concerning :SortMod do
      included do
        include ::SortMod
      end

      def sort_column_default
        :updated_at
      end
    end
  end
end
