require "google/apis/sheets_v4"
require "google/apis/drive_v3"
require "googleauth"

module GoogleApi
  # このクラスはただのユーティリティ関数の寄せ集めであって使い安さは考慮されていない
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

    def authorize
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds({json_key_io: StringIO.new(json_content), scope: SCOPE})
      authorizer.fetch_access_token!
      authorizer
    end

    def json_content
      if false
        Rails.root.join("config/google_account_json/shogi-web-production-93737ceaabf3.json").read
        Rails.root.join("config/google_account_json/shogi-web-development-2792594c71a6.json").read
      else
        Rails.application.credentials.dig(:google_api, Rails.env).to_json
      end
    end

    def spreadsheet_create(title = nil)
      spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(properties: { title: title || "New Spreadsheet" })
      @sheets_service.create_spreadsheet(spreadsheet)
    end

    # スプレッドシートを削除するメソッド
    def spreadsheet_delete(spreadsheet_id)
      @drive_service.delete_file(spreadsheet_id)
      Rails.logger.info "Spreadsheet with ID #{spreadsheet_id} deleted successfully."
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
