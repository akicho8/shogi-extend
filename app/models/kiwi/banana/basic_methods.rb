module Kiwi
  class Banana
    concern :BasicMethods do
      included do
        belongs_to :user, class_name: "::User"
        belongs_to :lemon

        delegate :advanced_kif_info, to: :lemon

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

        scope :public_only_with_user, -> params {
          s = all.public_only
          if current_user = params[:current_user]
            if false
              s = s.or(current_user.kiwi_bananas)
            end
          end
          s
        }

        scope :search_by_search_preset_key, -> params {
          v = params[:search_preset_key].presence || SearchPresetInfo.first.key
          SearchPresetInfo.fetch(v).func.call(all, params)
        }

        scope :search_by_tag, -> params {
          if v = params[:tag].to_s.split(/[,\s]+/).presence
            where(id: tagged_with(v))
          end
        }

        scope :search_by_query, -> params {
          if v = params[:query].presence
            v = [
              v,
              NKF.nkf("-w --hiragana", v),
              NKF.nkf("-w --katakana", v),
            ].uniq.collect { |e| "%#{e}%" }
            s = where(arel_table[:title].matches_any(v))
            s = s.or(where(arel_table[:description].matches_any(v)))
          end
        }

        scope :general_search, -> params {
          s = joins(:folder, :user, :lemon)
          s = s.search_by_search_preset_key(params)
          s = s.search_by_tag(params)
          s = s.search_by_query(params)
          s
        }

        before_validation do
          self.folder_key ||= :private
          # self.sequence_key ||= :bananaship_shuffle
          self.key ||= secure_random_urlsafe_base64_token
          self.thumbnail_pos ||= 0

          if user
            self.title = title.presence || "#{user.name}の動画(#{user.kiwi_bananas.count.next})"
          end

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

        after_validation do
          if changes_to_save[:thumbnail_pos]
            if lemon
              lemon.thumbnail_build(thumbnail_pos)
            end
          end
        end
      end

      def page_url(options = {})
        UrlProxy.full_url_for("/video/watch/#{key}")
      end

      # jsから来たパラメーターでまとめて更新する
      #
      #   params = {
      #     "title"            => "(title)",
      #     "init_sfen"        => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
      #     "moves_answers"    => [{"moves_str"=>"4c5b"}],
      #   }
      #   banana = user.kiwi_bananas.build
      #   banana.update_from_js(params)
      #   banana.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]
      #
      def update_from_js(params)
        params = params.symbolize_keys
        old_new_record = new_record?

        attrs = params.slice(*[
            :title,
            :description,
            :folder_key,
            :lemon_id,
            :tag_list,
            :thumbnail_pos,
          ])
        assign_attributes(attrs)
        save!

        changed_then_notify
      end

      def og_meta
        {
          :title       => [title, user.name].compact.join(" - "),
          :description => description || "",
          :og_image    => lemon.og_image_path,
          :og_video    => lemon.og_video_path,
        }
        # if new_record?
        #   {
        #     :title       => "新規 - 動画",
        #     :description => description || "",
        #     :og_image    => lemon.og_image_path,
        #     :og_video    => lemon.og_video_path,
        #   }
        # else
        # end
      end

      def tweet_body
        list = [
          title,
          *tag_list,
          "将棋動画",
        ]
        list.collect { |e| "#" + e.gsub(/[\p{blank}-]+/, "_") }.join(" ")
      end

      def form_values_default_assign
        return if persisted?

        # localStorage から復帰する属性は埋めない
        if false
          self.folder_key ||= :public
        end

        # 元動画の情報から拾えるものは拾って埋める
        if lemon
          self.tag_list = tag_list.presence || [:defense, :attack, :technique, :note].flat_map do |e|
            lemon.recordable.public_send("#{e}_tag_list")
          end

          if s = lemon.all_params.dig(:media_builder_params, :cover_text).presence # dig を使うな
            a = s.lines
            self.title       ||= a.first.strip
            self.description ||= a.drop(1).join.strip
          end
        end

        if Rails.env.development?
          if user
            self.title ||= "#{user.name}の動画#{user.kiwi_bananas.count.next}"
          end
          self.title       ||= "あ" * 80
          self.description ||= "い" * 256
        end

        self.title         ||= ""
        self.description   ||= ""
        self.thumbnail_pos ||= 0
      end

      private

      def changed_then_notify
        if saved_changes?
          str = created_at == updated_at ? "作成" : "更新"
          SlackAgent.message_send(key: "動画#{str}", body: [title, page_url].join(" "))
          subject = "#{user.name}さんが動画「#{title}」を#{str}"
          body = info.collect { |k, v| "#{k}: #{v}\n" }.join
          SystemMailer.simple_track(subject: subject, body: body).deliver_later
        end
      end
    end
  end
end
