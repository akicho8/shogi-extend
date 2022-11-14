module Swars
  class User
    concern :GradeMethods do
      included do
        custom_belongs_to :grade, ar_model: Grade, st_model: GradeInfo, default: "30級" # すべてのモードのなかで一番よい段級位

        if Rails.env.development? || Rails.env.test?
          before_validation do
            if Grade.count.zero?
              Swars.setup
            end
          end
        end
      end

      # 指定の grade の方が段位が上であれば設定する
      def grade_update_if_new(new_grade)
        if grade
          if new_grade.priority < grade.priority
            self.grade = new_grade
          end
        else
          self.grade = grade
        end
        save!
      end

      def name_with_grade
        "#{user_key} #{grade.name}"
      end
    end
  end
end
