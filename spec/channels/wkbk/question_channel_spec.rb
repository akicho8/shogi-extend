require "rails_helper"

RSpec.describe Wkbk::QuestionChannel, type: :channel do
  include WkbkSupportMethods

  it do
    expect {
      question1.messages.create!(user: user1, body: "message")
    }.to have_broadcasted_to("wkbk/question_channel/#{question1.id}")
  end
end
