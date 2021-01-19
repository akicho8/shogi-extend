# 将棋問題集
#
# entry
#   app/controllers/api/wbook_controller.rb
#
# vue
#   app/javascript/wbook_app/index.vue
#
# db
#   db/migrate/20200505135600_create_wbook.rb
#
# test
#   experiment/0860_wbook.rb
#
# model
#   app/models/wbook/membership.rb
#   app/models/wbook/battle.rb
#   app/models/wbook.rb
#   app/models/colosseum/user_wbook_mod.rb
#
#   question
#     app/models/wbook/question.rb
#     app/models/wbook/moves_answer.rb
#
# channel
#   app/channels/wbook/lobby_channel.rb
#   app/channels/wbook/battle_channel.rb
#
# job
#   app/jobs/wbook/lobby_broadcast_job.rb
#   app/jobs/wbook/message_broadcast_job.rb
#

module Api
  class WbookController < ::Api::ApplicationController
    # FIXME: GET, PUT で分けるのではなく関心で分離する
    include GetApi
    include PutApi
    include ZipDlMod

    include DebugMod

    # self.script_name = "将棋問題集"
    # self.page_title = ""
    # self.form_position = :bottom
    # self.column_wrapper_enable = false

    # if Rails.env.production?
    #   self.visibility_hidden_on_menu = true
    # end

    # delegate :current_user, to: :h

    # http://0.0.0.0:3000/api/wbook
    def show
      if v = params[:remote_action]
        v = public_send(v)
        if performed?
          return
        end
        render json: v
        return
      end

      # # for OGP
      # case
      # when e = current_question
      #   ogp_params_set({
      #       :card        => :summary_large_image,
      #       :title       => e.title_with_author,
      #       :description => e.description,
      #       :image       => e.shared_image_params,
      #       :creator     => e.user.twitter_key,
      #     })
      # when e = User.find_by(id: params[:user_id])
      #   ogp_params_set({
      #       :card        => :summary,
      #       :title       => "#{e.name}さんのプロフィール",
      #       :description => "",
      #       :image       => e.avatar_path,
      #       :creator     => e.twitter_key,
      #     })
      # else
      #   ogp_params_set({
      #       :title       => "将棋問題集",
      #       :description => "クイズ形式で将棋の問題を解く力を競う対戦ゲームです",
      #     })
      # end

      ################################################################################

      info = {}
      info[:config] = Wbook::Config
      info[:mode] ||= "lobby"   # FIXME: とる
      # info[:api_path] = h.url_for(script_link_path)
      info[:question_default_attributes] = Wbook::Question.default_attributes

      warp_to_params_set(info)  # current_user のデータを作ることもあるので current_user のセットの前で行うこと

      if current_user
        info[:current_user] = current_user.as_json_type9x
      end

      # if Rails.env.development?
      #   Wbook::BaseChannel.redis_clear
      # end

      # http://0.0.0.0:3000/api/wbook.json
      if request.format.json?
        render json: info
        return
      end

      # zip の場合はここにくるっぽい

      ################################################################################

      # out = ""
      # out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
      # out += %(<div id="app"><wbook_app :info='#{info.to_json}' /></div>)
      # out
    end

    def update
      v = public_send(params[:remote_action])
      raise v.inspect unless v.kind_of?(Hash)
      render json: v
    end

    def current_battle_id
      params[:battle_id].presence
    end

    def current_battle
      if v = current_battle_id
        Wbook::Battle.find_by(id: v)
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
          Wbook::Question.find(v)
        end
      end
    end
  end
end
