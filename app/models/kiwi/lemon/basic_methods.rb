module Kiwi
  class Lemon
    concern :BasicMethods do
      included do
        belongs_to :user                          # 所有者
        belongs_to :recordable, polymorphic: true # 棋譜情報
        has_one :book                             # アーカイブしたときに結びつく

        scope :standby_only,     -> { where(process_begin_at: nil)                                } # 未処理
        scope :done_only,        -> { where.not(process_end_at: nil)                              } # 処理済み(失敗しても入る)
        scope :processing_only,  -> { where.not(process_begin_at: nil).where(process_end_at: nil) } # 処理中
        scope :process_started,  -> { where.not(process_begin_at: nil)                            } # 開始以降
        scope :ordered_process,  -> { where(process_begin_at: nil).order(:created_at)             } # 上から処理する順
        scope :ordered_not_done, -> { where(process_end_at: nil).order(:created_at)               } # 完了していないもの(順序付き)
        scope :not_done_only,    -> { where(process_end_at: nil)                                  } # 完了していないもの
        scope :error_only,       -> { where.not(errored_at: nil)                                  } # 失敗したもの
        scope :success_only,     -> { where.not(successed_at: nil)                                } # 成功したもの

        # BUG: Hash を指定すると {} が null になるため、偶然空になったとき NOT NULL 制約でDB保存できない → 仕様らしい
        # https://github.com/rails/rails/issues/42928
        # https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization/ClassMethods.html#method-i-serialize
        serialize :all_params
        serialize :ffprobe_info

        before_validation do
          self.all_params ||= {}
          self.all_params = all_params.deep_symbolize_keys
          MediaBuilder.params_rewrite!(all_params[:media_builder_params])

          # XXX: error_message が "" とき予想に反して "".lines が [] になり first して転けるため present? で除外するの重要
          if changes_to_save[:error_message] && v = error_message.presence
            self.error_message = v.lines.first.first(self.class.columns_hash["error_message"].limit)
          end
        end
      end

      def reset
        self.process_begin_at = nil
        self.process_end_at = nil
        self.successed_at = nil
        self.ffprobe_info = nil
        self.file_size = nil
        self.errored_at = nil
        self.error_message = nil
      end

      def share_board_params
        {
          :body               => recordable.sfen_body.tr(" ", "."),
          :turn               => recordable.display_turn,
          :abstract_viewpoint => all_params.dig(:media_builder_params, :viewpoint),
          :color_theme_key    => all_params.dig(:media_builder_params, :color_theme_key),
          :xfont_key          => all_params.dig(:media_builder_params, :xfont_key),
        }.compact
      end
    end
  end
end
