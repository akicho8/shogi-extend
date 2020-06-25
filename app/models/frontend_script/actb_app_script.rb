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

      # for OGP
      if e = current_question
        c.instance_variable_set(:@ogp_params, {
            :title       => e.title,
            :description => e.description,
            :image       => e.shared_image_params,
            :creator     => e.user.twitter_key,
          })
      end

      zip_dl_process
      if c.performed?
        return
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

    def current_user_json
      current_user.as_json(only: [:id, :key, :name], methods: [:avatar_path, :rating, :skill_key, :description, :twitter_key])
    end

    def users
      [current_user, User.bot]
    end

    # http://localhost:3000/script/actb-app.zip?command=question_download
    def zip_dl_process
      if request.format.zip? && params[:command] == "question_download"
        t = Time.current

        zip_buffer = Zip::OutputStream.write_buffer do |zos|
          zip_scope.each do |record|
            zos.put_next_entry("#{record.id}_#{record.title}.kif")
            sfen = record.main_sfen
            kif = Bioshogi::Parser.parse(sfen).to_kif
            kif = kif.gsub(/^.*の備考.*\n/, "")
            if c.current_body_encode == :sjis
              kif = kif.tosjis
            end
            zos.write(kif)
          end
        end

        sec = "%.2f s" % (Time.current - t)
        c.slack_message(key: "ZIP #{sec}", body: zip_filename)
        c.send_data(zip_buffer.string, type: Mime[params[:format]], filename: zip_filename, disposition: "attachment")
        return
      end
    end

    def zip_filename
      parts = []
      parts << current_user.name
      parts << "将棋問題集"
      parts << Time.current.strftime("%Y%m%d%H%M%S")
      parts << c.current_body_encode
      parts << zip_scope.count
      str = parts.compact.join("_") + ".zip"
      str.public_send("to#{c.current_body_encode}")
    end

    def zip_scope
      Actb::Question.all
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
