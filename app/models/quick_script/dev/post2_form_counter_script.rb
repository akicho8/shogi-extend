module QuickScript
  module Dev
    class Post2FormCounterScript < Base
      self.title = "POST実行2"
      self.description = "POST で送信したときだけフォームのカウンタを更新する"
      self.form_method = :post

      def form_parts
        super + [
          {
            :label   => "カウンタ",
            :key     => :my_counter,
            :type    => :integer,
            :default => @my_counter,
          },
        ]
      end

      def call
        @my_counter = params[:my_counter].to_i
        if request_post?
          @my_counter += 1
        end
        nil
      end
    end
  end
end
