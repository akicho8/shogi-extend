require "rails_helper"

RSpec.describe DataUri, type: :model do
  describe "参照系" do
    let(:source) { "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABlBMVEUAAP////973JksAAAAAWJLR0QB/wIt3gAAAAd0SU1FB+YIHwktKVmKpzsAAAALSURBVAjXY2BABQAAEAABocUhwQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMi0wOC0zMVQwOTo0NTo0MSswMDowMCXHz4IAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjItMDgtMzFUMDk6NDU6NDErMDA6MDBUmnc+AAAAAElFTkSuQmCC" }

    let(:object) { DataUri.new(source) }

    it "to_blob" do
      assert2 { object.to_blob.size == 276 }
    end

    it "to_data_uri" do
      assert2 { object.to_data_uri == source }
    end

    it "read" do
      assert2 { object.read }
    end

    it "mime" do
      assert2 { object.mime }
    end

    it "content_type" do
      assert2 { object.content_type == "image/png" }
    end

    it "extension" do
      assert2 { object.extension == "png" }
    end

    it "stream" do
      assert2 { object.stream }
    end

    it "inspect" do
      assert2 { object.inspect == "#<DataUri image/png (276 bytes)>" }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> DataUri
# >>   参照系
# >>     to_blob
# >>     to_data_uri
# >>     read
# >>     mime
# >>     content_type
# >>     extension
# >>     stream
# >>     inspect
# >> 
# >> Top 5 slowest examples (1.05 seconds, 35.0% of total time):
# >>   DataUri 参照系 content_type
# >>     0.25021 seconds -:25
# >>   DataUri 参照系 to_blob
# >>     0.24613 seconds -:9
# >>   DataUri 参照系 mime
# >>     0.19704 seconds -:21
# >>   DataUri 参照系 read
# >>     0.18591 seconds -:17
# >>   DataUri 参照系 to_data_uri
# >>     0.17259 seconds -:13
# >> 
# >> Finished in 3.01 seconds (files took 6.03 seconds to load)
# >> 8 examples, 0 failures
# >> 
