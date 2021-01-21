module Wbook
  module UserMod
    extend ActiveSupport::Concern

    included do
      include FolderMod

      # このユーザーが作成した問題(複数)
      has_many :wbook_questions, class_name: "Wbook::Question", dependent: :destroy do
        def create_mock1(attrs = {})
          create!(attrs) do |e|
            if e.moves_answer_validate_skip.nil?
              e.moves_answer_validate_skip = true
            end
            e.title ||= SecureRandom.hex
            e.init_sfen ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
            e.moves_answers.build(moves_str: "G*5b")
          end
        end
      end
    end

    concerning :UserInfoMethods do
      # rails r "tp User.first.wbook_info"
      def wbook_info
        {
          "ID"   => id,
          "名前" => name,
        }
      end
    end
  end
end
