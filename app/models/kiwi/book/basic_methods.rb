module Kiwi
  class Book
    concern :BasicMethods do
      included do
        belongs_to :user, class_name: "::User"
        belongs_to :lemon

        acts_as_taggable

        scope :sorted, -> info {
          if info[:sort_column] && info[:sort_order]
            s = all
            table, column = info[:sort_column].to_s.scan(/\w+/)
            case table
            when "user"
              s = s.joins(:user).merge(User.reorder(column => info[:sort_order]))
            when "folder"
              s = s.joins(:folder).merge(Folder.reorder(column => info[:sort_order])) # position の order を避けるため reorder
            else
              s = s.order(info[:sort_column] => info[:sort_order])
              s = s.order(id: :desc) # 順序揺れ防止策
            end
          end
        }

        scope :search, -> params {
          if ["public", "limited", "private"].include?(params[:scope])
            if current_user = params[:current_user]
              s = current_user.kiwi_books.folder_eq(params[:scope])
            else
              s = none
            end
          else
            s = public_only
            # # ログインしていればプライベートな動画も混ぜる
            if current_user = params[:current_user]
              s = s.or(current_user.kiwi_books.joins(:folder))
              # s = s.or(current_user.kiwi_books.folder_eq(:public))
            end
          end

          base = s.joins(:folder, :user)
          s = base
          if v = params[:tag].to_s.split(/[,\s]+/).presence
            s = s.where(id: tagged_with(v))
          end
          if v = params[:query].presence
            v = [
              v,
              NKF.nkf("-w --hiragana", v),
              NKF.nkf("-w --katakana", v),
            ].uniq.collect { |e| "%#{e}%" }
            s = s.where(arel_table[:title].matches_any(v))
            s = s.or(base.where(arel_table[:description].matches_any(v)))
            s = s.or(base.where(User.arel_table[:name].matches_any(v)))
          end
          # SELECT kiwi_books.* FROM kiwi_books INNER JOIN kiwi_folders ON kiwi_folders.id = kiwi_books.folder_id INNER JOIN users ON users.id = kiwi_books.user_id WHERE (title LIKE '%a%' OR description LIKE '%a%')"
          # SELECT kiwi_books.* FROM kiwi_books INNER JOIN kiwi_folders ON kiwi_folders.id = kiwi_books.folder_id INNER JOIN users ON users.id = kiwi_books.user_id WHERE ((title LIKE '%a%' OR description LIKE '%a%') OR users.name LIKE '%a%')"
          # SELECT kiwi_books.* FROM kiwi_books INNER JOIN kiwi_folders ON kiwi_folders.id = kiwi_books.folder_id INNER JOIN users ON users.id = kiwi_books.user_id WHERE (((title LIKE '%%a%%') OR (description LIKE '%%a%%')) OR users.name LIKE '%a%')"
          s
        }

        before_validation do
          self.folder_key ||= :private
          # self.sequence_key ||= :bookship_shuffle
          self.key ||= secure_random_urlsafe_base64_token

          # if Rails.env.test? || Rails.env.development?
          #   self.title       ||= key
          #   self.description ||= "(description)"
          # end

          normalize_zenkaku_to_hankaku(:title, :description)
          normalize_blank_to_empty_string(:title, :description)
        end

        with_options presence: true do
          validates :title
          validates :lemon_id
        end

        with_options allow_blank: true do
          validates :title, uniqueness: { scope: :user_id, case_sensitive: true, message: "が重複しています" }
          validates :title, length: { maximum: 100 }
          validates :description, length: { maximum: 5000 }
          validates :lemon_id, uniqueness: { message: "はすでに登録しています" }
        end
      end

      def page_url(options = {})
        UrlProxy.wrap2("/video/books/#{key}")
      end

      # jsから来たパラメーターでまとめて更新する
      #
      #   params = {
      #     "title"            => "(title)",
      #     "init_sfen"        => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
      #     "moves_answers"    => [{"moves_str"=>"4c5b"}],
      #   }
      #   book = user.kiwi_books.build
      #   book.update_from_js(params)
      #   book.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]
      #
      def update_from_js(params)
        book = params.deep_symbolize_keys
        old_new_record = new_record?

        ActiveRecord::Base.transaction do
          attrs = book.slice(*[
              :title,
              :description,
              :folder_key,
              :lemon_id,
              :tag_list,
              # :sequence_key,
              # :new_file_src,    # nil 以外が来たらそれで画像作成
              # :raw_avatar_path, # nil が来たら画像削除
            ])
          assign_attributes(attrs)
          save!

          # ids = book[:ordered_bookships].collect { |e| e.fetch(:id) }
          # bookships_order_by_ids(ids)
        end

        simple_track
      end

      def simple_track
        str = created_at == updated_at ? "作成" : "更新"
        SlackAgent.message_send(key: "動画#{str}", body: [title, page_url].join(" "))
        subject = "#{user.name}さんが動画「#{title}」を#{str}"
        body = info.collect { |k, v| "#{k}: #{v}\n" }.join
        SystemMailer.simple_track(subject: subject, body: body).deliver_later
      end

      # articles の並び替え
      #
      #   user = User.create!
      #   book = user.kiwi_books.create!
      #   book.articles << user.kiwi_articles.create!(key: "a")
      #   book.articles << user.kiwi_articles.create!(key: "b")
      #
      #   book.articles.order(:position).pluck(:key) # => ["a", "b"]
      #   book.bookships_order_by_ids(["b", "a"])
      #   book.articles.order(:position).pluck(:key) # => ["b", "a"]
      #
      # 次の方法の方がわかりやすいかもしれないけどSQLがさらに articles.count 回発生する
      #
      #   Bookship.acts_as_list_no_update do
      #     keys.each.with_index do |key, i|
      #       bookship = book.bookships.joins(:article).find_by!(Article.arel_table[:key].eq(key))
      #       bookship.position = i
      #       bookship.save!(validate: false, touch: false)
      #     end
      #   end
      #
      # def bookships_order_by_ids(ids)
      #   table = bookships.inject({}) {|a, e| a.merge(e.id => e) }
      #   Bookship.acts_as_list_no_update do
      #     ids.each.with_index do |id, i|
      #       e = table.fetch(id)
      #       e.position = i
      #       e.save!(validate: false, touch: false)
      #     end
      #   end
      # end

      def og_image_path
        avatar_path
      end

      def og_meta
        if new_record?
          {
            :title       => "新規 - 動画",
            :description => description || "",
            :og_image    => "video-books",
          }
        else
          {
            :title       => [title, user.name].join(" - "),
            :description => description || "",
            :og_image    => og_image_path || "video-books",
          }
        end
      end

      def tweet_body
        list = [
          title,
          *tag_list,
          "動画",
        ]
        list.collect { |e| "#" + e.gsub(/[\p{blank}-]+/, "_") }.join(" ")
      end

      def default_assign
        # これらは localStorage から復帰する
        # self.folder_key ||= :public

        if lemon
          if cover_text = lemon.all_params[:media_builder_params][:cover_text].presence
            self.title ||= cover_text.lines.first.strip
            self.description ||= cover_text.lines.drop(1).join.strip + "\n"
          end
        end

        if Rails.env.development?
          if user
            self.title ||= "#{user.name}の動画#{user.kiwi_books.count.next}"
          end
          self.title       ||= "あ" * 80
          self.description ||= "い" * 256
        end

        self.title       ||= ""
        self.description ||= ""
        self.tag_list    ||= []
      end

      private

      # 公開した直後か？
      # def public_folder_posted?
      #   saved_change_to_attribute?(:folder_id) && folder_eq(:public)
      # end
    end
  end
end
