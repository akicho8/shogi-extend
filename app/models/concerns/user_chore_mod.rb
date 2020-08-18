module UserChoreMod
  extend ActiveSupport::Concern

  class_methods do
    def ghost_destroy_all
      ids = XyRecord.all.pluck("user_id").uniq
      s = User.all
      s = s.where.not(id: ids)
      s = s.where(["email like ?", "%@localhost%"])
      s = s.where("sign_in_count <= 1")
      s = s.where(["name like ?", "%名無し%"])
      s = s.limit(100)
      Actb.count_diff do
        s.each do |r|
          if r.actb_histories.count == 0 && r.actb_questions.count == 0
            r.destroy!
          end
        end
      end
    end
  end

  def show_path
    Rails.application.routes.url_helpers.url_for([self, only_path: true])
  end
end
