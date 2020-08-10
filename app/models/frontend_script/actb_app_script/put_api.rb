module FrontendScript
  class ActbAppScript
    concern :PutApi do

      # 更新することでマッチング結果はこちらが対象になる
      # curl -d _method=put -d _user_id=1 -d remote_action=session_lock_token_set_handle -d session_lock_token=xxx http://localhost:3000/script/actb-app.json
      def session_lock_token_set_handle
        raise ArgumentError, params.inspect if params[:session_lock_token].blank?
        # if current_user.actb_setting.session_lock_token
        #   return { error_message: "" }
        # end
        current_user.actb_setting.update!(session_lock_token: params[:session_lock_token])
        { status: "success" }
      end

      # curl -d _method=put -d _user_id=1 -d remote_action=session_lock_token_valid_handle -d session_lock_token=xxx http://localhost:3000/script/actb-app.json
      def session_lock_token_valid_handle
        raise ArgumentError, params.inspect if params[:session_lock_token].blank?
        if current_user.session_lock_token_valid?(params[:session_lock_token])
          { status: "success" }
        else
          { status: "session_lock_token_invalid" }
        end
      end

      # curl -d _method=put -d _user_id=1 -d remote_action=session_lock_token_reset_handle http://localhost:3000/script/actb-app.json
      # def session_lock_token_reset_handle
      #   current_user.actb_setting.update!(session_lock_token: nil)
      #   { status: "success" }
      # end

      # curl -d _method=put -d _user_id=1 -d remote_action=rule_key_set_handle -d rule_key=sy_marathon http://localhost:3000/script/actb-app.json
      def rule_key_set_handle
        raise ArgumentError, params.inspect if params[:session_lock_token].blank?
        unless current_user.session_lock_token_valid?(params[:session_lock_token])
          return { status: "session_lock_token_invalid" }
        end
        current_user.actb_setting.update!(rule: Actb::Rule.fetch(params[:rule_key]))
        { status: "success" }
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
        { status: "success" }
      end

      # 解散
      def matching_users_clear_handle
        Actb::Rule.matching_users_clear
        { status: "success" }
      end

      # マッチング中の人といきなり対局する
      def new_challenge_accept_handle
        raise if params[:session_lock_token].blank?

        ids = Actb::Rule.matching_all_user_ids
        raise if ids.any? { |e| !e.kind_of?(Integer) }
        ids = ids - [current_user.id]
        if ids.empty?
          return { status: "opponent_missing" }
        end
        id = ids.sample
        user = User.find(id)
        current_user.actb_setting.update!(session_lock_token: params[:session_lock_token])
        Actb::Room.create_with_members!([user, current_user], rule: user.actb_setting.rule)
        { status: "success" }
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
        user = current_user

        if v = params[:croped_image]
          bin = data_base64_body_to_binary(v)
          io = StringIO.new(bin)
          user.avatar.attach(io: io, filename: "user_icon.png")
        end

        user.name = params[:name]
        user.profile.description = params[:profile_description]
        user.profile.twitter_key = params[:profile_twitter_key]
        if user.invalid?
          return { error_message: user.errors.full_messages.join(" ") }
        end
        user.save!
        { user: user.as_json_type9 }
      end

      def append_tag_list_input_handle
        question = Actb::Question.find(params[:question_id])
        before_tags = question.owner_tag_list
        question.owner_tag_list = question.owner_tag_list + params[:append_tag_list]
        question.save!

        if current_user
          diff_tags = question.owner_tag_list - before_tags
          if diff_tags.present?
            str = diff_tags.collect { |e| h.tag.b(e) }.join("と")
            User.bot.lobby_speak("#{current_user.name}さんが#{question.linked_title}にタグ#{str}を追加しました")
          end
        end

        { owner_tag_list: question.owner_tag_list }
      end

      def notification_opened_handle
        current_user.notifications.find(params[:notification_unopen_ids]).each do |e|
          e.update!(opened_at: Time.current)
        end
        { status: "success" }
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
