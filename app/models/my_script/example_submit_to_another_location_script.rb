module MyScript
  class ExampleSubmitToAnotherLocationScript < Base
    self.label_name = "別のところにsubmit"

    def form_parts
      [
        {
          :type => :hidden,
        }
      ]
    end

    # フォームの型を一致させておいて別のフォームに飛ばしたいときなどに使う
    def script_body
      params # GETならとりあえずここは呼ばれる。POSTなら呼ばれない。
    end

    def submit_path
      script_link_path(:id => :index)
    end
  end
end
