# 汎用メニュービルダー
#
# ▼簡単に使うには？
#
#     MenuBuilder.render(view_context) do |menu|
#       menu << {:name => "Top",  :url => proc { top_path  }, :if_match => {:controller => "tops"}}
#       menu << {:name => "Home", :url => proc { home_path }, :if_match => {:controller => "homes"}}
#     end
#
# ▼ブロックなしで書くには？
#
#     menu = MenuBuilder.new(view_context)
#     menu << {:name => "Top",  :url => proc { top_path  }, :if_match => {:controller => "tops"}}
#     menu << {:name => "Home", :url => proc { home_path }, :if_match => {:controller => "homes"}}
#     menu.to_s # => HTML文字列
#
# ▼出力は？
#
#       li.active
#         a[href="top"]= "Top"
#       li
#         a[href="home"]= "Home"
#
# ▼気をつけることは？
#
#     ・ul は自分で付けること
#     ・メニュー要素がアクティブかどうかの判別には :if_match または :if が指定できる
#     ・動的に条件がかわる場合は view_context が引数で受けとれる :if = -> view_context {} を使う
#     ・url も proc で view_context が受けとれる
#
# ▼TIPS
#
#   li に対して active をつけたい          → そのままでOK
#   a  に対して active をつけたい          → :mark_place => :a
#   両方に active をつけたい               → :mark_place => :both
#   active はつけない                      → :mark_place => nil
#   active ではなく selected にしたい      → :selected_class => "selected"
#   li で囲みたくない                      → :wrapper_tag => nil, :mark_place => :a
#   li はすべてに foo クラスをつけときたい → :wrapper_options => "foo"
#
# ▼自分用
#   wrapper_tag を nil したとき :mark_place => :a にしないと active クラスがつかないので、
#   自動的に wrapper_tag が nil のときは :mark_place => :a すればいいと思うかもしれないけどわざとやってない
#   だいたい使うとき、内部でこの自動化が行なわれていることに気づかず、なぜ勝手にオプションが切りかわっているのかわからず不安になる
#   このあたりはあえてマニュアル的な仕様にしといた方がいい
#

require "active_support/core_ext/module/delegation"

class MenuBuilder
  def self.render(*args, &block)
    new(*args, &block).to_s
  end

  attr_accessor :view_context, :options, :elements

  alias h view_context

  delegate :params, :content_tag, :link_to, :link_to_unless, :request, :controller, :to => :view_context

  def initialize(view_context, **options, &block)
    @view_context = view_context

    @options = {
      :link_options    => {},       # link_to につけるオプション
      :selected_class  => "active", # 有効なときのクラス
      :wrapper_tag     => "li",     # 一要素ごと指定のタグで囲む。nil を指定すると囲まない。
      :wrapper_options => {},       # wrapper_tag の指定があるとき、そのタグにつけるオプション
      :mark_place      => :wrapper, # :a :wrapper :both のどれかを指定する。有効なときクラスはどっちにいれるのかが決まる。bothなら両方
      :separator       => "\n",     # 最後に join するときのセパレーター
    }.merge(options)

    @elements = []

    if block_given?
      yield self
    end
  end

  def <<(element)
    if element
      @elements << element
    end
  end

  def to_s
    build_elements.collect(&:to_s).join(@options[:separator]).html_safe
  end

  def build_elements
    @elements.collect { |e| Element.new(self, e) }
  end

  class Element
    attr_accessor :base

    def initialize(base, elem)
      @base = base
      @elem = elem
    end

    def to_s
      if @elem.kind_of?(String)
        return @elem
      end
      @options = base.options.deep_merge(@elem)
      s = base.link_to(@elem[:name], url, link_options)
      if @options[:wrapper_tag]
        s = base.content_tag(@options[:wrapper_tag], s, wrapper_options)
      end
      s
    end

    private

    def link_options
      options = @options[:link_options].merge(@elem[:link_options] || {})
      options.merge(:class => (Array(options[:class]) + [link_class_if_active]).flatten.compact.join(" ").squish)
    end

    def wrapper_options
      if @options[:wrapper_tag]
        options = @options[:wrapper_options].merge(@elem[:wrapper_options] || {})
        options.merge(:class => (Array(options[:class]) + [wrapper_class_if_active]).flatten.compact.join(" ").squish)
      end
    end

    def link_class_if_active
      if selected?
        if @options[:mark_place].in?([:a, :both])
          @options[:selected_class]
        end
      end
    end

    def wrapper_class_if_active
      if selected?
        if @options[:mark_place].in?([:wrapper, :both])
          @options[:selected_class]
        end
      end
    end

    def url
      if @elem[:url].respond_to?(:call)
        @elem[:url].call(base.h)
      else
        @elem[:url]
      end
    end

    def selected?
      if @elem[:if]
        @elem[:if].call(base.h)
      elsif @elem[:if_match]
        selected_by(@elem[:if_match])
      end
    end

    # 現在どのメニューが選択されているのかを調べる
    #
    #  引数                                            マッチするparams
    #  {:controller => "admin/articles"}               # {:controller => "admin/articles"}
    #  {:controller => Admin::ArtclesController}       # {:controller => "admin/articles"}
    #  {:controller => "articles", :action => "index"} # {:controller => "articles", :action => "index"}
    #  {:controller => %r/\b(articles)\z/}             # {:controller => "何か/articles"}
    #  {:action => "index"}                            # {:action => "index"}
    #  {:action => /index/}                            # {:action => "foo_index"}
    #  {:action => [:new, :edit]}                      # {:action => "new"} または {:action => "edit"}
    #  {:query => "a"}                                 # {:query => "a"}
    #
    def selected_by(matches)
      matches.all? do |key, val|
        if key == :controller && val.kind_of?(Class)
          base.controller.kind_of?(val)
        else
          s = base.params[key].to_s
          case val
          when String, Symbol
            s == val.to_s
          when Regexp
            !!s.match(val)
          when Array
            val.collect(&:to_s).include?(s)
          else
            raise ArgumentError, "#{key}: #{val}"
          end
        end
      end
    end
  end
end

if $0 == __FILE__
  require "active_support/all"

  require "rspec/autorun"
  RSpec.configure do |config|
    config.include RSpec::Mocks::ExampleMethods
  end
  RSpec::Mocks.setup
  RSpec::Mocks.configuration.syntax = :should

  describe MenuBuilder do
    before do
      @view_context = double("view_context")
      @view_context.stub(:link_to) {|name, url, link_options| [:link_to, name, url, link_options]}
      @view_context.stub(:link_to_unless) {|selected, name, url, link_options| [selected, name, url, link_options]}
      @view_context.stub(:params).and_return({})
      @view_context.stub(:request).and_return({})
      @view_context.stub(:content_tag) {|tag, body, options| [tag.to_sym, options, body]}
    end

    it "elementsに文字列を入れることもできるのでサブメニューを作れる" do
      menu = MenuBuilder.new(@view_context)
      menu << "a"
      menu << "b"
      expect(menu.to_s).to eq "a\nb"
    end

    describe "options" do
      before do
        @view_context.stub(:params).and_return({:controller => "foo"})
      end

      def options_test(options = {})
        menu = MenuBuilder.new(@view_context, options)
        menu << {:name => "name1", :url => "url1", :if_match => {:controller => "foo"}}
        menu.build_elements.collect(&:to_s)
      end

      describe "どこに active をつけるか決める mark_place オプション" do
        it "デフォルトではliに対してactiveが付く" do
          expect(options_test).to eq [[:li, {:class => "active"}, [:link_to, "name1", "url1", {:class => ""}]]]
        end
        it "liではなくaに対してactiveをつける場合は :a を指定する" do
          expect(options_test(:mark_place => :a)).to eq [[:li, {:class => ""}, [:link_to, "name1", "url1", {:class => "active"}]]]
        end
        it "おすすめしないが両方にactiveをつける場合は :both を指定する" do
          expect(options_test(:mark_place => :both)).to eq [[:li, {:class => "active"}, [:link_to, "name1", "url1", {:class => "active"}]]]
        end
      end

      it "liで囲まない(この場合自動的に change_where は :a になる)" do
        expect(options_test(:wrapper_tag => nil, :mark_place => :a)).to eq [[:link_to, "name1", "url1", {:class => "active"}]]
      end
    end
  end
end
