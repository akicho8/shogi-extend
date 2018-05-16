#
# 期間を持つモデル用
#
#   マイグレーション:
#     create_table :articles do |t|
#       t.datetime :begin_at, :null => false    # 開始日時
#       t.datetime :end_at,   :null => false    # 終了日時
#     end
#
#   モデル:
#     class Article < ApplicationRecord
#       time_rangable
#     end
#
#   メタメソッド:
#     Article.time_rangable_defined?   ; time_rangable が使えるか？
#     Article.time_rangable?           ; time_rangable 実行済みか？
#
#   スコープ:
#     time_future ; 開始未満
#     time_begin  ; 開始以上
#     time_noend  ; 終了未満
#     time_past   ; 終了以上
#     time_active ; 開始以上〜終了未満
#
#   クラスメソッド
#     time_active? ; 開始以上〜終了未満 のものが存在するか？
#
#   インスタンスメソッド:
#     time_future?     ; 開始未満？
#     time_begin?      ; 開始以降？
#     time_noend?      ; 終了未満？
#     time_past?       ; 終了以上？
#     time_active?     ; 開始以上〜終了未満？
#     time_default_set ; 初期値設定(オーバーライド可)
#     time_status      ; 状態を文字列で返す
#     time_status_scope_key; スコープのキーに変換
#     time_info        ; 期間を文字列で返す
#
#   区分の表記
#        begin_at   end_at   ; カラム
#     -------+--------+-----
#      future|begin          ; 開始未満・開始以上
#                noend|past  ; 終了未満・終了以上
#            | active |      ; 開始以上〜終了未満
#

require 'active_support/concern'
require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/time/zones'

module TimeRangable
  extend ActiveSupport::Concern

  # begin_at end_at メソッドを持っているクラスに気軽に include できるモジュール
  concern :GeneralInstanceMethods do
    class TimeStatusScopeInfo
      include ApplicationStaticRecord
      static_record [
        {:key => :time_future, :name => "待機中", :color => :success, :order => {:begin_at => :asc }, :tooltip => "もうすぐ開始するもの順", },
        {:key => :time_active, :name => "期間中", :color => :danger,  :order => {:end_at   => :asc }, :tooltip => "もうすぐ終わるもの順",   },
        {:key => :time_past,   :name => "おわり", :color => :default, :order => {:end_at   => :desc}, :tooltip => "最近終わったもの順",     },
      ], :attr_reader_auto => true
    end

    def time_future?
      Time.current < begin_at
    end

    def time_begin?
      !time_future?
    end

    def time_noend?
      !time_past?
    end

    def time_past?
      end_at <= Time.current
    end

    def time_active?
      time_begin? && time_noend?
    end

    # 設定がないときは常に無効とする
    def safe_time_active?
      time_range_exist? && time_active?
    end

    # 開始までの残り秒数
    def time_left_to_begin_at
      time_left_to_xxx_at(begin_at)
    end

    # 終了までの残り秒数
    def time_left_to_end_at
      time_left_to_xxx_at(end_at)
    end

    def time_status
      if time_future?
        "future"
      elsif time_active?
        "active"
      elsif time_past?
        "past"
      else
        raise "must not happen"
      end
    end

    def time_status_scope_key
      :"time_#{time_status}"
    end

    def time_status_scope_info
      if time_range_exist?
        TimeStatusScopeInfo.fetch_if(time_status_scope_key)
      end
    end

    def time_info(format = :yymdhms)
      "#{begin_at.to_s(format)}...#{end_at.to_s(format)}"
    end

    # self.time_range ||= ... をできるように片方が nil なら nil を返すようにしている
    def time_range
      if time_range_exist?
        begin_at...end_at
      end
    end

    def time_range_exist?
      begin_at && end_at
    end

    def time_range=(value)
      if value
        raise ArgumentError, "a..b ではなく a...b のように期間の最後は期間を含まないようにしてください : #{value.inspect}" unless value.exclude_end?
        self.begin_at = value.begin
        self.end_at   = value.end
      else
        self.begin_at = nil
        self.end_at   = nil
      end
    end

    private

    def time_left_to_xxx_at(t)
      if t
        [t - Time.current, 0].max.ceil
      end
    end
  end

  class_methods do
    def time_rangable(options = {})
      options = {
        :default => true,
      }.merge(options)

      include SingletonMethods

      if options[:default]
        before_save :time_default_set
      end
    end

    def time_rangable_defined?
      ancestors.include?(SingletonMethods)
    end
  end

  concern :SingletonMethods do
    include GeneralInstanceMethods

    included do
      scope :time_future, proc {|t=Time.current| where(arel_table[:begin_at].gt(t))}   # begin_at > t
      scope :time_begin,  proc {|t=Time.current| where(arel_table[:begin_at].lteq(t))} # begin_at <= t
      scope :time_noend,  proc {|t=Time.current| where(arel_table[:end_at].gt(t))}     # end_at > t
      scope :time_past,   proc {|t=Time.current| where(arel_table[:end_at].lteq(t))}   # end_at < t
      scope :time_active, proc {|t=Time.current| time_begin(t).time_noend(t)}          # begin_at <= t && end_at > t
    end

    class_methods do
      def time_rangable?
        time_rangable_defined?
      end

      def time_active?
        time_active.exists?
      end

      # null object 的なインタフェースを作るとき用
      #
      #   例えば次のようにして使うと event_state が nil を返したときの煩雑な分岐が必要なくなる
      #
      #     def event_state
      #       EventState.fetch(event_state_key) || EventState.time_null_object
      #     end
      #
      #     event_state.time_active?
      #
      #   nil ならすべての範囲とするなら
      #
      #     def event_state
      #       EventState.fetch(event_state_key) || EventState.time_wide_object
      #     end
      #
      def time_null_object
        new(:time_range => time_range_default.begin...time_range_default.begin)
      end

      def time_wide_object
        new(:time_range => time_range_default)
      end

      def time_range_default
        Time.zone.parse("2000/01/01")...Time.zone.parse("2050/01/01")
      end
    end

    def time_default_set
      self.time_range ||= self.class.time_range_default
      true
    end
  end
end
