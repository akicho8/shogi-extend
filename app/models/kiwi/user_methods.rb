# user = User.create!
# lemon = user.kiwi_lemons.create!
# lemon.articles << user.kiwi_articles.create!(key: "a")
# lemon.articles << user.kiwi_articles.create!(key: "b")

module Kiwi
  module UserMethods
    extend ActiveSupport::Concern

    included do
      has_many :lemons, dependent: :destroy, class_name: "Kiwi::Lemon"
    end

    # 自分が所有していて完了したもの
    def kiwi_my_records_singlecast
      bc_params = {
        # :my_records => lemons.done_only.limit(5).order(created_at: :desc).as_json(Kiwi::Lemon.json_struct_for_list),
        :my_records => lemons.limit(Kiwi::Lemon.user_history_max).order(created_at: :desc).as_json(Kiwi::Lemon.json_struct_for_list),
      }
      Kiwi::GlobalRoomChannel.broadcast_to(self, {bc_action: :kiwi_my_records_singlecasted, bc_params: bc_params})
    end

    # 終了したもの
    def kiwi_done_record_singlecast(done_record, params = {})
      bc_params = {
        :done_record => done_record.as_json(Kiwi::Lemon.json_struct_for_done_record),
        :noisy => true,
        **params,
      }
      Kiwi::GlobalRoomChannel.broadcast_to(self, {bc_action: :kiwi_done_record_singlecasted, bc_params: bc_params})
    end

    # 進捗
    def kiwi_progress_singlecast(bc_params)
      Kiwi::GlobalRoomChannel.broadcast_to(self, {bc_action: :kiwi_progress_singlecasted, bc_params: bc_params})
    end
  end
end
