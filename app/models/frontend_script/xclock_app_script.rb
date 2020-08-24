# 将棋トレーニングバトル！
#
# entry
#   app/models/frontend_script/xclock_app_script.rb
#
# vue
#   app/javascript/xclock_app/index.vue
#
# db
#   db/migrate/20200505135600_create_xclock.rb
#
# test
#   experiment/0860_xclock.rb
#
# model
#   app/models/xclock/membership.rb
#   app/models/xclock/battle.rb
#   app/models/xclock.rb
#   app/models/colosseum/user_xclock_mod.rb
#
#   question
#     app/models/xclock/question.rb
#     app/models/xclock/moves_answer.rb
#
# channel
#   app/channels/xclock/lobby_channel.rb
#   app/channels/xclock/battle_channel.rb
#
# job
#   app/jobs/xclock/lobby_broadcast_job.rb
#   app/jobs/xclock/message_broadcast_job.rb
#
module FrontendScript
  class XclockAppScript < ::FrontendScript::Base
    self.script_name = "対局時計"
    self.page_title = ""
    self.form_position = :bottom
    self.column_wrapper_enable = false

    if Rails.env.production?
      self.visibility_hidden_on_menu = true
    end

    delegate :current_user, to: :h

    def script_body
      ogp_params_set

      info = {}
      info[:config] = {}

      if request.format.json?
        return info
      end

      c.layout_type = :raw

      out = ""
      out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
      out += %(<div id="app"><xclock_app :info='#{info.to_json}' /></div>)
      out
    end
  end
end
