require "./setup"
client = Aws::Polly::Client.new
resp = client.synthesize_speech({
    :text            => "こんにちは",
    :response_target => "_output.mp3",
    :output_format   => "mp3",
    :sample_rate     => "16000",
    :text_type       => "text",
    :voice_id        => "Mizuki",
  })
tp resp.to_h
# >> |--------------------+-----------------------------------------------------|
# >> |       audio_stream | #<Seahorse::Client::ManagedFile:0x00007f87ad96fc80> |
# >> |       content_type | audio/mpeg                                          |
# >> | request_characters | 5                                                   |
# >> |--------------------+-----------------------------------------------------|
