require 'rails_helper'

RSpec.describe XmovieRecord, type: :model do
  include XmovieSupport

  def entry_only
    free_battle = user1.free_battles.create!(kifu_body: params1[:body], use_key: "adapter")
    user1.xmovie_records.create!(recordable: free_battle, convert_params: params1[:xmovie_record_params])
  end

  it "works" do
    record = entry_only
    record.main_process!
    record.reload
    assert { record.status_key == "成功" }
    assert { record.browser_path.match?(%{/system/x-files/.*mp4}) }
  end

  it "background_job_kick" do
    entry_only
    XmovieRecord.background_job_kick
  end

  it "process_in_sidekiq" do
    entry_only
    XmovieRecord.process_in_sidekiq
  end

  it "zombie_kill" do
    XmovieRecord.zombie_kill
  end

  it "info" do
    entry_only
    assert { XmovieRecord.info }
  end

  it "everyone_broadcast" do
    entry_only
    XmovieRecord.everyone_broadcast
  end
end
