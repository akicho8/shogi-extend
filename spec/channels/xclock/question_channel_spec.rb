require "rails_helper"

RSpec.describe Xclock::QuestionChannel, type: :channel do
  include XclockSupportMethods

  it do
    expect {
      question1.messages.create!(user: user1, body: "message")
    }.to have_broadcasted_to("xclock/question_channel/#{question1.id}")
  end
end
