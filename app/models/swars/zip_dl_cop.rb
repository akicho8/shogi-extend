module Swars
  class ZipDlMan
    include EncodeMod

    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def to_config
      config = {}
      config[:form_params_default] = {
        :zip_scope_key  => "latest",
        :zip_format_key => "kif",
        :encode_key     => "UTF-8",
        :zip_dl_max     => AppConfig[:zip_dl_max_default],
      }

      if current_user
        s = swars_zip_dl_logs
        s = s.order(:end_at)
        config[:swars_zip_dl_logs] = {
          :count => s.count,
          :last  => s.last,
        }

        config[:scope_info] = ZipDlScopeInfo.collect do |e|
          {
            :key   => e.key,
            :name  => instance_eval(&e.name),
            :count => instance_eval(&e.scope).count,
          }
        end
      end

      config
    end

    def zip_io
      t = Time.current

      io = Zip::OutputStream.write_buffer do |zos|
        zip_scope.each do |battle|
          if str = battle.to_xxx(kifu_format_info.key)
            zos.put_next_entry("#{swars_user.key}/#{battle.key}.#{kifu_format_info.key}")
            if current_body_encode == "Shift_JIS"
              str = str.encode(current_body_encode)
            end
            zos.write(str)
          end
        end
      end

      sec = "%.2f s" % (Time.current - t)
      SlackAgent.message_send(key: "ZIP #{sec}", body: zip_filename)

      # 前回から続きのスコープが変化すると zip_filename にも影響するので最後の最後に呼ぶ
      swars_zip_dl_logs_create!

      io
    end

    def zip_filename
      parts = []
      parts << "shogiwars"
      parts << swars_user.key
      parts << zip_scope.count
      parts << Time.current.strftime("%Y%m%d%H%M%S")
      parts << kifu_format_info.key
      parts << current_body_encode
      str = parts.compact.join("-") + ".zip"
      str
    end

    # 続きから進められるようにダウンロード範囲を記録する
    def swars_zip_dl_logs_create!
      swars_zip_dl_logs_create2(zip_scope)
    end

    # 続きから進められるようにダウンロード範囲を記録する
    def swars_zip_dl_logs_create2(s)
      if s.exists?
        a = s.first.battled_at
        b = s.last.battled_at
        a, b = [a, b].sort
        current_user.swars_zip_dl_logs.create! do |e|
          e.swars_user = swars_user
          e.query      = params[:query]
          e.dl_count   = s.count
          e.begin_at   = a            # 単なる記録なのでなくてもよい
          e.end_at     = b + 1.second # 次はこの日時以上を対象にする
        end
      end
    end

    # 古い1件をダウンロードしたことにする
    def huruinowo_dl
      scope = current_index_scope.order(battled_at: :asc).limit(1)
      swars_zip_dl_logs_create2(scope)
    end

    private

    def zip_scope
      instance_eval(&zip_dl_scope_info.scope)
    end

    def zip_dl_max
      (params[:zip_dl_max].presence || AppConfig[:zip_dl_max_default]).to_i.clamp(0, AppConfig[:zip_dl_max_of_max])
    end

    def kifu_format_info
      @kifu_format_info ||= Bioshogi::KifuFormatInfo.fetch(zip_format_info.key)
    end

    def zip_format_info
      ZipFormatInfo.fetch(zip_format_key)
    end

    def zip_format_key
      params[:zip_format_key].presence || "kif"
    end

    def continue_begin_at
      if current_user
        s = current_user.swars_zip_dl_logs
        s = s.where(swars_user: swars_user)
        s = s.order(:end_at)
        if e = s.last
          e.end_at
        end
      end
    end

    def swars_zip_dl_logs
      @swars_zip_dl_logs ||= current_user.swars_zip_dl_logs.where(swars_user: swars_user)
    end

    def zip_dl_scope_info
      ZipDlScopeInfo.fetch(zip_scope_key)
    end

    def zip_scope_key
      (params[:zip_scope_key].presence || :latest).to_sym
    end

    def current_user
      params[:current_user] or raise ArgumentError
    end

    def swars_user
      @swars_user ||= User.find_by!(key: swars_user_key)
    end

    # いまのところ query はユーザー名しか入っていない前提とする
    # 本当は query からスコープを作りたいのだけどコントローラーに書いたところが他からアクセスできないのでいまのところこうなっている
    def swars_user_key
      params[:query].split.first.presence or raise ArgumentError
    end

    # swars_user.battles としてもよいが query から構築したスコープを使いたい
    def current_index_scope
      params[:current_index_scope] or raise ArgumentError
    end
  end
end
