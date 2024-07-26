module QuickScript
  module Chore
    class MarkdownScript < Base
      self.title = "Markdown表示"
      self.description = "markdown を JS 側の marked を使って変換表示する"

      def call
        { _component: "MarkdownContent", _v_bind: { body: markdown_text }, :class => "content" }
      end

      def markdown_text
        <<~EOT
## H2の見出し ##

親譲りの無鉄砲で小供の時から損ばかりしている。小学校に居る時分学校の二階から飛び降りて一週間ほど腰を抜かした事がある。なぜそんな無闇をしたと聞く人があるかも知れぬ。別段深い理由でもない。新築の二階から首を出していたら、同級生の一人が冗談に、いくら威張っても、そこから飛び降りる事は出来まい。弱虫やーい。と囃したからである。小使に負ぶさって帰って来た時、おやじが大きな眼をして二階ぐらいから飛び降りて腰を抜かす奴があるかと云ったから、この次は抜かさずに飛んで見せますと答えた。

```html
<my-tag></my-tag>
```

と、書くのは冗長なのでずっと

```html
<my-tag/>
```

と書いていた。そしてこれは**普通に動いていた**。

が、あるとき二つ続けて書くと一つしか出ないことに気づいた。次のように書いて、

```html
<my-tag/>
<my-tag/>
```

デベロッパーツールで確認すると `<my-tag></my-tag>` が一つあるだけだった。エラーが出ることもなく片方は消えていた。

試しに下のように変更すると問題なく2つ表示された。

```html
<my-tag></my-tag>
<my-tag></my-tag>
```

## H2見出し ##

- A
  - A1
  - A2
- B
  - B1
  - B2

https://html.spec.whatwg.org/multipage/syntax.html#void-elements
EOT
      end
    end
  end
end
