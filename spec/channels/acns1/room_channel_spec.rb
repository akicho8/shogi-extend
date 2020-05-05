# spec/channels/chat_channel_spec.rb

require "rails_helper"

RSpec.describe Acns1::RoomChannel, type: :channel do
  let :user do
    Colosseum::User.create!
  end

  let :room do
    Acns1::Room.create!
  end

  before do
    # initialize connection with identifiers
    stub_connection room_id: room.id
  end

  it "subscribes without streams when no room id" do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).not_to have_streams
  end

  # it "rejects when room id is invalid" do
  #   subscribe(room_id: -1)
  #
  #   expect(subscription).to be_rejected
  # end
  #
  # it "subscribes to a stream when room id is provided" do
  #   subscribe(room_id: 42)
  #
  #   expect(subscription).to be_confirmed
  #
  #   # check particular stream by name
  #   expect(subscription).to have_stream_from("chat_42")
  #
  #   # or directly by model if you create streams with `stream_for`
  #   expect(subscription).to have_stream_for(Room.find(42))
  # end
end

# class Acns1::RoomChannel < ApplicationCable::Channel
#   def subscribed
#     stream_from "acns1/room_channel/#{params['room_id']}"
#   end
#
#   def unsubscribed
#     # Any cleanup needed when channel is unsubscribed
#   end
#
#   def speak(data)
#     Acns1::Message.create!(body: data['message'], user: current_user, room_id: params['room_id'])
#   end
# end
