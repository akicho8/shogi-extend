require "rails_helper"

RSpec.describe XfileCleaner do
  it "works" do
    ["foo.png", "foo.png.rb"].each do |name|
      file = MediaBuilder.output_root_dir.join(name)
      file.write("")
      file.utime(Time.current.to_time, Time.current.to_time)
    end
    object = XfileCleaner.new(expires_in: 0.days, execute: true)
    object.call
    assert { object.subject.include?("x-files 以下削除 2個") }
    assert { ActionMailer::Base.deliveries.present? }
  end
end
