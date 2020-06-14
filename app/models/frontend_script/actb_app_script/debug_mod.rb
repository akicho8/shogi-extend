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

      def debug_scene_set(info)
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

        rule_key = current_debug_scene.remove("battle_")
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

        room = Actb::Room.create_with_members!(users)
        battle = room.battle_create_with_members!(final: Actb::Final.fetch(:f_disconnect))
        battle.memberships[0].update!(judge: Actb::Judge.fetch(:win))
        battle.memberships[1].update!(judge: Actb::Judge.fetch(:lose))
        battle.reload

        info[:room] = room.as_json_type4
        info[:battle] = battle.as_json_type2
      end

      # 問題作成(一覧)
      def debug_for_builder(info)
      end

      # 問題作成(配置)
      def debug_for_builder_haiti(info)
      end

      # 問題作成(情報)
      def debug_for_builder_form(info)
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
        info[:question_id] = Actb::Question.first&.id
      end

      # ユーザー詳細
      def debug_for_ov_user_info(info)
      end

      # ログインしていない状態
      def debug_for_no_login_lobby(info)
      end
    end
  end
end
