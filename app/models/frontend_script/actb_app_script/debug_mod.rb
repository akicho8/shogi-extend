module FrontendScript
  class ActbAppScript
    concern :DebugMod do
      def form_parts
        if Rails.env.development?
          [
            {
              :label   => "画面",
              :key     => :debug_scene,
              :type    => :select,
              :default => current_debug_scene,
              :elems   => {
                "ロビー"                       => nil,
                "プロフィール編集"             => :profile_edit,
                "プロフィール画像アップロード" => :profile_edit_image_crop,
                "対戦(マラソン)"               => :battle_marathon_rule,
                "対戦(シングルトン)"           => :battle_singleton_rule,
                "対戦(ハイブリッド)"           => :battle_hybrid_rule,
                "結果"                         => :result,

                "問題作成(一覧)"               => :builder,
                "問題作成(配置)"               => :builder_haiti,
                "問題作成(情報)"               => :builder_form,

                "ランキング"                   => :ranking,
                "履歴"                         => :history,
                "問題詳細"                     => :ov_question_info,
                "ユーザー詳細"                 => :ov_user_info,
                "ログインしている状態"         => :login_lobby,
                "ログインしていない状態"       => :no_login_lobby,
              },
            },
          ]
        end
      end

      def current_debug_scene
        if v = params[:debug_scene].presence
          v.to_sym
        end
      end

      def debug_scene_params_set(info)
        if current_debug_scene
          info[:debug_scene] = current_debug_scene
          send("debug_for_#{current_debug_scene}", info)
        end
      end

      private

      # ログインしている状態でロビー
      def debug_for_login_lobby(info)
        c.sysop_login_unless_logout
      end

      # プロフィール編集
      def debug_for_profile_edit(info)
        c.sysop_login_unless_logout
      end

      # プロフィール画像アップロード
      def debug_for_profile_edit_image_crop(info)
      end

      # 対戦(マラソン)
      def debug_for_battle_marathon_rule(info)
        c.sysop_login_unless_logout

        rule_key = current_debug_scene.to_s.remove("battle_")
        rule = Actb::Rule.fetch(rule_key)

        room = Actb::Room.create_with_members!(users, rule: rule)
        battle = room.battle_create_with_members!

        info[:room] = room.as_json_type4
        info[:battle] = battle.as_json_type1
      end

      # 対戦(シングルトン)
      def debug_for_battle_singleton_rule(info)
        debug_for_battle_marathon_rule(info)
      end

      # 対戦(ハイブリッド)
      def debug_for_battle_hybrid_rule(info)
        debug_for_battle_marathon_rule(info)
      end

      # 結果
      def debug_for_result(info)
        c.sysop_login_unless_logout

        users.each do |user|
          record = user.actb_main_xrecord
          record.skill_key = "A+"
          record.skill_point = 50
          record.save!
        end

        record = users[0].actb_main_xrecord
        record.skill_add(60)
        record.save!

        record = users[1].actb_main_xrecord
        record.skill_add(60)
        record.save!

        room = Actb::Room.create_with_members!(users)
        battle = room.battle_create_with_members!(final: Actb::Final.fetch(:f_disconnect))
        battle.memberships[0].update!(judge: Actb::Judge.fetch(:win))
        battle.memberships[1].update!(judge: Actb::Judge.fetch(:lose))
        battle.reload

        info[:room] = room.as_json_type4
        info[:battle] = battle.as_json_type2_for_result
      end

      # 問題作成(一覧)
      def debug_for_builder(info)
        c.sysop_login_unless_logout
      end

      # 問題作成(配置)
      def debug_for_builder_haiti(info)
        c.sysop_login_unless_logout
      end

      # 問題作成(情報)
      def debug_for_builder_form(info)
        c.sysop_login_unless_logout
      end

      # ランキング
      def debug_for_ranking(info)
        c.sysop_login_unless_logout
      end

      # 履歴
      def debug_for_history(info)
        c.sysop_login_unless_logout
      end

      # 問題詳細
      def debug_for_ov_question_info(info)
        c.sysop_login_unless_logout

        question = Actb::Question.first
        question.title = "始まりの金" * 10
        question.direction_message = "3手指してください" * 10
        question.assign_attributes({
            :source_about_key       => "ascertained",
            :source_author          => "渡瀬荘二郎",
            :source_media_name      => "Wikipedia",
            :source_media_url       => "https://ja.wikipedia.org/wiki/%E5%AE%9F%E6%88%A6%E5%9E%8B%E8%A9%B0%E5%B0%86%E6%A3%8B",
            :source_published_on    => "1912-03-04",
          })
        question.save!

        info[:question_id] = question.id
      end

      # ユーザー詳細
      def debug_for_ov_user_info(info)
        c.sysop_login_unless_logout

        e = current_user.actb_main_xrecord
        e.win_count = 1
        e.lose_count = 2
        e.save!

        current_user.profile.update!(description: [
            "http://www.google.co.jp/",
            "あああああああああああああああああああああああああああああああああああああああああああああああああああああ",
            "@sgkinakomochi",
          ].join("\n"))
      end

      # ログインしていない状態
      def debug_for_no_login_lobby(info)
        info.delete(:current_user)
      end
    end
  end
end
