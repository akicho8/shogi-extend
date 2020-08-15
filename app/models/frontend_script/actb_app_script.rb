# 将棋トレーニングバトル！
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
    include ZipDlMod

    include DebugMod

    self.script_name = "将棋トレーニングバトル！"
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

      # for OGP
      case
      when e = current_question
        ogp_params_set({
            :card        => :summary_large_image,
            :title       => e.title_with_author,
            :description => e.description,
            :image       => e.shared_image_params,
            :creator     => e.user.twitter_key,
          })
      when e = User.find_by(id: params[:user_id])
        ogp_params_set({
            :card        => :summary,
            :title       => "#{e.name}さんのプロフィール",
            :description => "",
            :image       => e.avatar_path,
            :creator     => e.twitter_key,
          })
      else
        ogp_params_set({
            :title       => "将棋トレーニングバトル！",
            :description => "クイズ形式で将棋の問題を解く力を競う対戦ゲームです",
          })
      end

      # JS 側からいきなりログイン画面に飛ばすとどこに戻ればよいかわからない
      # なのでいったんここに飛ばして return_to を設定させてログイン画面に飛ぶ
      if params[:goto_login]
        h.session[:return_to] = h.url_for(:training)
        c.redirect_to :new_xuser_session
        return
      end

      ################################################################################

      info = {}
      info[:config] = Actb::Config
      info[:mode] ||= "lobby"   # FIXME: とる
      info[:api_path] = h.url_for(script_link_path)
      info[:question_default_attributes] = Actb::Question.default_attributes

      if current_user
        info[:current_user] = current_user.as_json_type9

        if true
          # すでにログインしている人は x-cable で unauthorized になる
          # これはクッキーに記録しないままログインしたのが原因
          # なのですでにログインしていたらクッキーに埋める
          c.current_user_set_for_action_cable(current_user)
        end
      end

      warp_to_params_set(info)

      # if Rails.env.development?
      #   Actb::BaseChannel.redis_clear
      # end

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
      v = public_send(params[:remote_action])
      raise v.inspect unless v.kind_of?(Hash)
      c.render json: v
    end

    def current_battle_id
      params[:battle_id].presence
    end

    def current_battle
      if v = current_battle_id
        Actb::Battle.find_by(id: v)
      end
    end

    def users
      [current_user, User.bot]
    end

    concerning :QuestionOgpMethods do
      def current_question
        @current_question ||= __current_question
      end

      def __current_question
        if v = params[:question_id]
          Actb::Question.find(v)
        end
      end
    end
  end
end
