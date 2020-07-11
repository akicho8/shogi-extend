module FrontendScript
  class ActbAppScript
    concern :PutApi do
      # curl -d _method=put -d remote_action=rule_key_set_handle -d rule_key=marathon_rule http://localhost:3000/script/actb-app.json
      def rule_key_set_handle
        current_user.actb_setting.update!(rule: Actb::Rule.fetch(params[:rule_key]))
        true
      end

      # 自分以外の誰かを指定ルールに参加させる
      def debug_matching_add_handle
        if user = User.where.not(id: params[:exclude_user_id]).first
          Actb::Rule.matching_users_delete_from_all_rules(user)
          if rule_key = params[:rule_key]
            rule = Actb::Rule.fetch(rule_key)
            user.actb_setting.update!(rule: rule)
          else
            rule = current_user.actb_setting.rule
          end
          rule.matching_users_add(user)
        end
        true
      end

      # 解散
      def matching_users_clear_handle
        Actb::Rule.matching_users_clear
        true
      end

      def vote_handle
        current_user.vote_handle(params)
      end

      def clip_handle
        current_user.clip_handle(params)
      end

      def save_handle
        if id = params[:question][:id]
          question = Actb::Question.find(id)
        else
          question = current_user.actb_questions.build
        end
        begin
          question.update_from_js(params[:question])
        rescue ActiveRecord::RecordInvalid => error
          return { form_error_message: error.message }
        end
        { question: question.as_json(Actb::Question.json_type5) }
      end

      # curl -d _method=put -d user_name=a -d remote_action=profile_update -d _user_id=1 http://localhost:3000/script/actb-app
      def profile_update
        if v = params[:croped_image]
          bin = data_base64_body_to_binary(v)
          io = StringIO.new(bin)
          current_user.avatar.attach(io: io, filename: "user_icon.png")
        end

        if v = params[:user_name]
          current_user.update!(name: v)
        end

        if v = params[:user_description]
          current_user.profile.update!(description: v)
        end

        if v = params[:user_twitter_key]
          current_user.profile.update!(twitter_key: v)
        end

        { current_user: current_user.as_json_type9 }
      end

      private

      # from app/javascript/actb_app/the_profile_edit_form.vue profile_update_handle
      def data_base64_body_to_binary(data_base64_body)
        md = data_base64_body.match(/\A(data):(?<content_type>.*?);base64,(?<base64_bin>.*)/)
        md or raise ArgumentError, "Data URL scheme 形式になっていません : #{data_base64_body.inspect.truncate(80)}"
        Base64.decode64(md["base64_bin"])
      end
    end
  end
end
