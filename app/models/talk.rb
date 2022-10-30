module Talk
  extend self

  # render json: Talk.create(source_text: "こんにちは")
  # # => {"browser_path":"/system/talk/main/df/a4/dfa49915a273d5639f1c7fbb237af8ec.mp3"}
  def create(params)
    Main.new(params)
  end
end
