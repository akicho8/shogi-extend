require "google/apis/sheets_v4"
require "google/apis/drive_v3"
require "googleauth"

module GoogleApi
  # このクラスは抽象度を上げるためにメソッドを寄せ集めただけであって使いやすさはまったく考慮されていない
  class Toolkit
    APPLICATION_NAME = "SHOGI-EXTEND"

    SCOPE = [
      Google::Apis::SheetsV4::AUTH_SPREADSHEETS,
      Google::Apis::DriveV3::AUTH_DRIVE_FILE,
    ]

    def initialize
      @sheets_service = Google::Apis::SheetsV4::SheetsService.new
      @sheets_service.client_options.application_name = APPLICATION_NAME
      @sheets_service.authorization = authorize

      @drive_service = Google::Apis::DriveV3::DriveService.new
      @drive_service.client_options.application_name = APPLICATION_NAME
      @drive_service.authorization = authorize
    end

    def dispatch(method, *args, **kwargs, &block)
      AppLog.info(subject: "[GoogleApi][Toolkit][START] #{method}")
      begin
        send(method, *args, **kwargs, &block)
      rescue => error
        AppLog.info(subject: "[GoogleApi][Toolkit][#{error.class.name}] #{method}", body: error)
        raise error
      end
    end

    def authorize
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds({ json_key_io: StringIO.new(json_content), scope: SCOPE })
      authorizer.fetch_access_token!
      authorizer
    end

    def json_content
      # return Rails.root.join("config/google_account_json/production.json").read
      # return Rails.root.join("config/google_account_json/local.json").read
      Rails.application.credentials.dig(:google_api, Rails.env).to_json
    end

    def spreadsheet_create(title = nil)
      spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(properties: { title: title || "New Spreadsheet" })
      instance = @sheets_service.create_spreadsheet(spreadsheet)
      AppLog.info(subject: "[API][Googleスプレッドシート][作成]", body: instance.spreadsheet_url)
      instance
    end

    def spreadsheet_delete(spreadsheet_id)
      @drive_service.delete_file(spreadsheet_id)
      AppLog.info(subject: "[API][Googleスプレッドシート][削除] #{spreadsheet_id}")
    end

    def spreadsheet_share(spreadsheet_id)
      permission = Google::Apis::DriveV3::Permission.new(type: "anyone", role: "reader")
      @drive_service.create_permission(spreadsheet_id, permission)
    end

    def spreadsheet_update(spreadsheet_id, range, values)
      value_range = Google::Apis::SheetsV4::ValueRange.new(range: range, values: values)
      @sheets_service.update_spreadsheet_value(spreadsheet_id, range, value_range, value_input_option: "USER_ENTERED") # RAW or USER_ENTERED
    end

    def cell_update(spreadsheet_id, requests)
      batch_update_request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: requests)
      @sheets_service.batch_update_spreadsheet(spreadsheet_id, batch_update_request)
    end
  end
end
