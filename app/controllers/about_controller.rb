class AboutController < ApplicationController
  def show
    # md = self.class.render(action: "#{params[:id]}.md", layout: false)
    # renderer = Redcarpet::Render::HTML.new
    # markdown = Redcarpet::Markdown.new(renderer)
    # html = markdown.render(md)
    # render html: html.html_safe, layout: true
  end

  def markdown_render
    md = self.class.render(action: "#{params[:id]}.md", layout: false)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer)
    html = markdown.render(md).html_safe
    # render html: html.html_safe, layout: true
  end
end
