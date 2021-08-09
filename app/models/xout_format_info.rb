# TWITTERに投稿できる動画と画像の仕様について ← めちゃくちゃ詳しい
# https://nico-lab.net/twitter_upload_format_spec/
#
# 色の情報の扱いについて
# https://nico-lab.net/setting_in_out_color_with_ffmpeg/
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
    # ../../front_app/components/xconv/models/xout_format_info.js
    { key: "is_format_gif",             name: "GIF",                  real_ext: "gif",  override_options: {},                      force_convert_to_yuv420p: false, },
    { key: "is_format_webp",            name: "WebP",                 real_ext: "webp", override_options: {},                      force_convert_to_yuv420p: false, },
    { key: "is_format_apng",            name: "APNG",                 real_ext: "apng", override_options: {},                      force_convert_to_yuv420p: false, },
    { key: "is_format_mp4_twitter",     name: "MP4",                  real_ext: "mp4",  override_options: {},                      force_convert_to_yuv420p: true,  },
    { key: "is_format_mov",             name: "MOV",                  real_ext: "mov",  override_options: {},                      force_convert_to_yuv420p: true,  },
    { key: "is_format_png",             name: "PNG",                  real_ext: "png",  override_options: {},                      force_convert_to_yuv420p: false, },
    { key: "is_format_jpg",             name: "JPG",                  real_ext: "jpg",  override_options: {},                      force_convert_to_yuv420p: false, },
    { key: "is_format_bmp",             name: "BMP",                  real_ext: "bmp",  override_options: {},                      force_convert_to_yuv420p: false, },
    { key: "is_format_mp4_yuv444p10le", name: "MP4 (yuv444p10le)",    real_ext: "mp4",  override_options: {},                      force_convert_to_yuv420p: false, },
    { key: "is_format_mp4_noopt",       name: "MP4 (noopt)",          real_ext: "mp4",  override_options: {optimize_layer: false}, force_convert_to_yuv420p: true,  },
  ]
end
