module UserXconvMethods
  extend ActiveSupport::Concern

  included do
    has_many :xconv_records, dependent: :destroy
  end

  # 自分が所有していて完了したもの
  def my_records_broadcast
    bc_params = {
      # :my_records => xconv_records.done_only.limit(5).order(created_at: :desc).as_json(XconvRecord.json_struct_for_list),
      :my_records => xconv_records.limit(5).order(created_at: :desc).as_json(XconvRecord.json_struct_for_list),
    }
    Xconv::RoomChannel.broadcast_to(self, {bc_action: :my_records_broadcasted, bc_params: bc_params})
  end

  # 終了したもの
  def done_record_broadcast(done_record)
    bc_params = {
      :done_record => done_record.as_json(XconvRecord.json_struct_for_done_record),
    }
    Xconv::RoomChannel.broadcast_to(self, {bc_action: :done_record_broadcasted, bc_params: bc_params})
  end
end
