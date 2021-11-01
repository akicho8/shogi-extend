require "rails_helper"

RSpec.describe Actb::QuestionChannel, type: :channel do
  include ActbSupport

  it do
    expect {
      question1.messages.create!(user: user1, body: "message")
    }.to have_broadcasted_to("actb/question_channel/#{question1.id}")
  end
end
