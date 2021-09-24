# user = User.create!
# lemon = user.kiwi_lemons.create!
# lemon.articles << user.kiwi_articles.create!(key: "a")
# lemon.articles << user.kiwi_articles.create!(key: "b")

module Kiwi
  module UserMethods
    extend ActiveSupport::Concern

    included do
      has_many :kiwi_lemons, class_name: "Kiwi::Lemon", dependent: :destroy

      # このユーザーが作成した本(複数)
      has_many :kiwi_books, class_name: "Kiwi::Book", dependent: :destroy do
        def create_mock1(attrs = {})
          create!(attrs) do |e|
            e.title ||= SecureRandom.hex
            e.description ||= SecureRandom.hex
          end
        end
      end
    end

    # 自分が所有していて完了したもの
    def kiwi_my_lemons_singlecast
      bc_params = {
        # :my_records => lemons.done_only.limit(5).order(created_at: :desc).as_json(Kiwi::Lemon.json_struct_for_list),
        :my_records => kiwi_lemons.limit(Kiwi::Lemon.user_history_max).order(created_at: :desc).as_json(Kiwi::Lemon.json_struct_for_list),
      }
      Kiwi::GlobalRoomChannel.broadcast_to(self, {bc_action: :kiwi_my_lemons_singlecasted, bc_params: bc_params})
    end

    # 終了したもの
    def kiwi_done_lemon_singlecast(done_record, params = {})
      bc_params = {
        :done_record => done_record.as_json(Kiwi::Lemon.json_struct_for_done_record),
        :noisy => true,
        **params,
      }
      Kiwi::GlobalRoomChannel.broadcast_to(self, {bc_action: :kiwi_done_lemon_singlecasted, bc_params: bc_params})
    end

    # 進捗
    def kiwi_progress_singlecast(bc_params)
      Kiwi::GlobalRoomChannel.broadcast_to(self, {bc_action: :kiwi_progress_singlecasted, bc_params: bc_params})
    end
  end
end
