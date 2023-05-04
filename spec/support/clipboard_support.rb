module ClipboardSupport
  extend ActiveSupport::Concern

  included do
    before do
    end
  end

  def assert_clipboard(regexp)
    if ENV["CLIPBOARD_CHECK"] == "off"
      puts "skip: assert_clipboard(#{regexp.inspect})"
      return
    end
    assert2 { Clipboard.read.match?(regexp) }
  end
end

RSpec.configure do |config|
  config.include(ClipboardSupport)
end
