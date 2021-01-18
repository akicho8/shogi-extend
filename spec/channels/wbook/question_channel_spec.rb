require "rails_helper"

RSpec.describe Wbook::QuestionChannel, type: :channel do
  include WbookSupportMethods

  it do
    expect {
      question1.messages.create!(user: user1, body: "message")
    }.to have_broadcasted_to("wbook/question_channel/#{question1.id}")
  end
end
