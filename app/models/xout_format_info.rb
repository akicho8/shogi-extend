# TWITTERに投稿できる動画と画像の仕様について
# https://nico-lab.net/twitter_upload_format_spec/
#
# TwitterにMP4動画をアップロードするにはyuv420pを使う必要がある（らしい）
# https://kivantium.hateblo.jp/entry/2017/07/16/160859
#
# ・yuv420p にすることで QuickTime で再生できる
# ・yuv420p にすることで Twitter に投稿できる
#

class XoutFormatInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "is_format_gif",         name: "GIF",           real_ext: "gif",  twitter_support: false, },
    { key: "is_format_webp",        name: "WebP",          real_ext: "webp", twitter_support: false, },
    { key: "is_format_apng",        name: "APNG",          real_ext: "apng", twitter_support: false, },
    { key: "is_format_mp4",         name: "MP4",           real_ext: "mp4",  twitter_support: false, },
    { key: "is_format_mp4_yuv420p", name: "MP4 (yuv420p)", real_ext: "mp4",  twitter_support: true,  },
    { key: "is_format_mov",         name: "MOV",           real_ext: "mov",  twitter_support: false, },
    { key: "is_format_png",         name: "PNG",           real_ext: "png",  twitter_support: false, },
    { key: "is_format_jpg",         name: "JPG",           real_ext: "jpg",  twitter_support: false, },
    { key: "is_format_bmp",         name: "BMP",           real_ext: "bmp",  twitter_support: false, },
  ]
end
