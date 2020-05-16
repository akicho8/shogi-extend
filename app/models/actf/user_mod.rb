module Actf
  concern :UserMod do
    included do
      # 対局
      has_many :actf_rooms, class_name: "Actf::Room", through: :memberships                           # 対局(複数)
      has_many :actf_memberships, class_name: "Actf::Membership", dependent: :restrict_with_exception # 対局時の情報(複数)

      # このユーザーが作成した問題(複数)
      has_many :actf_questions, class_name: "Actf::Question", dependent: :destroy

      # このユーザーに出題した問題(複数)
      has_many :actf_histories, class_name: "Actf::History", dependent: :destroy

      # チャット関連
      with_options(dependent: :destroy) do |o|
        has_many :actf_room_messages, class_name: "Actf::RoomMessage"
        has_many :actf_lobby_messages, class_name: "Actf::LobbyMessage"
      end

      # プロフィール
      has_one :actf_profile, class_name: "Actf::Profile", dependent: :destroy
      delegate :rating, :rensho_count, :rensho_max, to: :actf_profile
      after_create do
        actf_profile || create_actf_profile!
      end

      # Good/Bad
      has_many :actf_favorites, class_name: "Actf::Favorite", dependent: :destroy
      has_many :actf_good_marks, class_name: "Actf::GoodMark", dependent: :destroy
      has_many :actf_bad_marks, class_name: "Actf::BadMark", dependent: :destroy
      has_many :actf_clips, class_name: "Actf::Clip", dependent: :destroy
    end

    def vote_handle(params)
      question = Actf::Question.find(params[:question_id])
      vote_info = VoteInfo.fetch(params[:vote_key])
      retv = {}
      retv.update(question_vote_enable(question, vote_info, params[:vote_value]))
      retv.update(question_vote_enable(question, vote_info.flip, false))
      retv
    end

    private

    # 未使用
    def question_vote_toggle(question, vote)
      s = question_vote_scope(question, vote)
      if s.exists?
        s.destroy_all
        mark_on = false
        diff = -1
      else
        s.create!
        mark_on = true
        diff = 1
      end
      { "#{vote.key}_mark_on": mark_on, "#{vote.key}_diff": diff }
    end

    def question_vote_enable(question, vote, enable)
      s = question_vote_scope(question, vote)
      if enable
        if s.exists?
          diff = 0
        else
          s.create!
          diff = 1
        end
        mark_on = true
      else
        if s.exists?
          s.destroy_all
          diff = -1
        else
          diff = 0
        end
        mark_on = false
      end
      { "#{vote.key}_mark_on": mark_on, "#{vote.key}_diff": diff }
    end

    def question_vote_scope(question, vote)
      send("actf_#{vote.key}_marks").where(question: question)
    end
  end
end
