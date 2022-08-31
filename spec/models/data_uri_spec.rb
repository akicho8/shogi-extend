require "rails_helper"

RSpec.describe DataUri, type: :model do
  describe "参照系" do
    let(:object) { DataUri.new("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABlBMVEUAAP////973JksAAAAAWJLR0QB/wIt3gAAAAd0SU1FB+YIHwktKVmKpzsAAAALSURBVAjXY2BABQAAEAABocUhwQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMi0wOC0zMVQwOTo0NTo0MSswMDowMCXHz4IAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjItMDgtMzFUMDk6NDU6NDErMDA6MDBUmnc+AAAAAElFTkSuQmCC") }

    it "binary" do
      assert { object.binary.size == 276 }
    end

    it "read" do
      assert { object.read }
    end

    it "mime" do
      assert { object.mime }
    end

    it "content_type" do
      assert { object.content_type == "image/png" }
    end

    it "extension" do
      assert { object.extension == "png" }
    end

    it "io" do
      assert { object.io }
    end
  end
end
