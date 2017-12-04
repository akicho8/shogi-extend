# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

Mime::Type.register_alias "text/plain", :kif
Mime::Type.register_alias "text/plain", :kifu # Kifu.swf で kif を utf8 として読むための専用拡張子
Mime::Type.register_alias "text/plain", :ki2
Mime::Type.register_alias "text/plain", :csa
