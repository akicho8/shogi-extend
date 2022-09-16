module Clipboard
  extend self

  def write(text)
    IO.popen("pbcopy", "w") { |io| io.write(text) }
  end

  def read
    IO.popen("pbpaste", &:read)
  end
end
