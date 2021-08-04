# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

Mime::Type.register_alias "text/plain", :kif
Mime::Type.register_alias "text/plain", :ki2
Mime::Type.register_alias "text/plain", :csa
Mime::Type.register_alias "text/plain", :sfen
Mime::Type.register_alias "text/plain", :bod

# なぜか登録されていないので
# rails r 'p Mime["webp"]'
Mime::Type.register_alias "image/webp", :webp
