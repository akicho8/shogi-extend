# http://localhost:3000/api/wkbk/books/download?book_key=B92grdhLdHH
module Wkbk
  class BookArchive
    attr_accessor :params

    def initialize(params, options = {}, &block)
      @params = params
      @options = {}.merge(options)

      if block_given?
        yield self
      end
    end

    def to_send_data_params
      [to_zip.string, type: Mime[:zip], filename: zip_filename, disposition: "attachment"]
    end

    def to_zip
      t = Time.current

      io = Zip::OutputStream.write_buffer do |zos|
        current_scope.each.with_index(1) do |e, i|
          title = ("%03d" % i) + "_" + path_normalize(e.article.title)
          e.article.moves_answers.each.with_index(1) do |e, i|
            str = book.kif_header + e.to_kif
            # body_encodes.each do |encode|
            # path = "#{book_title}/#{encode}/#{title}/#{i}.kif"
            path = "#{book_title}/#{title}/#{i}.kif"
            entry = Zip::Entry.new(zos, path)
            entry.time = Zip::DOSTime.from_time(e.created_at)
            zos.put_next_entry(entry)
            s = str
            # if encode == "Shift_JIS"
            #   s = str.encode(encode)
            # end
            zos.write(s)
            # end
          end
        end
      end

      sec = "%.2f s" % (Time.current - t)
      AppLog.info(subject: "ZIP #{sec}", body: zip_filename)

      io
    end

    def current_scope
      s = book.bookships
      s = s.access_restriction_by(current_user) # 自分以外の場合は公開と限定公開のみとする
      s = book.sequence.pure_info.apply[s]      # 出題と同じ並び替えを行う
      s = s.joins(:article).includes(article: :moves_answers)
    end

    private

    def zip_filename
      parts = []
      parts << book_title
      parts << Time.current.strftime("%Y%m%d%H%M%S")
      parts.flatten.compact.join("-") + ".zip"
    end

    def book_title
      @book_title ||= path_normalize(book.title)
    end

    def path_normalize(str)
      StringSupport.path_normalize(str)
    end

    def body_encodes
      [
        "UTF-8",
        # "Shift_JIS",
      ]
    end

    def current_user
      params[:current_user]
    end

    def book
      params[:book]
    end
  end
end
