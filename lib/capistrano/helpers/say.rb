# namespace :notice do
#   desc "デプロイ失敗時に伝える"
#   task "failed" do
#     Say.call "デプロイに失敗しました"
#   end
#   after "deploy:failed", "notice:failed"
# end

require "shellwords"

class Say
  class << self
    def call(...)
      new(...).call
    end
  end

  def initialize(message, options = {})
    @message = message
    @options = {
    }.merge(options)
  end

  def call
    tp message
    if say_command_exist?
      escaped_message = Shellwords.escape(message)
      system "say #{escaped_message}"
    end
  end

  private

  def say_command_exist?
    system("which say > /dev/null 2>&1")
  end

  attr_reader :message
end
