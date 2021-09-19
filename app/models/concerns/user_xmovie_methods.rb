module UserXmovieMethods
  extend ActiveSupport::Concern

  included do
    has_many :xmovie_records, dependent: :destroy
  end

  # 自分が所有していて完了したもの
  def my_records_singlecast
    bc_params = {
      # :my_records => xmovie_records.done_only.limit(5).order(created_at: :desc).as_json(XmovieRecord.json_struct_for_list),
      :my_records => xmovie_records.limit(XmovieRecord.user_history_max).order(created_at: :desc).as_json(XmovieRecord.json_struct_for_list),
    }
    Xmovie::GlobalRoomChannel.broadcast_to(self, {bc_action: :my_records_singlecasted, bc_params: bc_params})
  end

  # 終了したもの
  def done_record_singlecast(done_record, params = {})
    bc_params = {
      :done_record => done_record.as_json(XmovieRecord.json_struct_for_done_record),
      :noisy => true,
      **params,
    }
    Xmovie::GlobalRoomChannel.broadcast_to(self, {bc_action: :done_record_singlecasted, bc_params: bc_params})
  end

  # 進捗
  def progress_singlecast(bc_params)
    Xmovie::GlobalRoomChannel.broadcast_to(self, {bc_action: :progress_singlecasted, bc_params: bc_params})
  end
end
