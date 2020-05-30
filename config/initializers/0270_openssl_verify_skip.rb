# A Faraday::SSLError
# SSL_connect returned=1 errno=0 state=error: certificate verify failed (certificate has expired)
#
# Faradayを使うとSSL関連のエラーが定期的にでる
# 2020-05-30 には常時エラーになってしまった
# なのでSSLチェックを無視する設定に変更してみる
#
# https://github.com/googleapis/google-api-ruby-client/issues/253#issue-94316624
# https://komiyak.hatenablog.jp/entry/20130508/1367993536
silence_warnings do
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
end
