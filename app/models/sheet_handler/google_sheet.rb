require "google/apis/sheets_v4"
require "google/apis/drive_v3"
require "googleauth"

module SheetHandler
  # このクラスはただのユーティリティ関数の寄せ集めであって使い安さは考慮されていない
  class GoogleSheet
    SCOPE = [
      Google::Apis::SheetsV4::AUTH_SPREADSHEETS,
      Google::Apis::DriveV3::AUTH_DRIVE_FILE,
    ]

    def initialize
      @sheets_service = Google::Apis::SheetsV4::SheetsService.new
      @sheets_service.client_options.application_name = "Your App Name"
      @sheets_service.authorization = authorize

      @drive_service = Google::Apis::DriveV3::DriveService.new
      @drive_service.client_options.application_name = "Your App Name"
      @drive_service.authorization = authorize
    end

    def authorize
      if true
        json_content = Rails.root.join("config/google_account_json/shogi-web-development-06e32c3bc3b3.json").read
      else
        json_content = Rails.application.credentials.dig(:google_api, Rails.env).to_json
      end
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds({json_key_io: StringIO.new(json_content), scope: SCOPE})
      authorizer.fetch_access_token!
      authorizer
    end

    def spreadsheet_create(title)
      spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(properties: { title: title })
      @sheets_service.create_spreadsheet(spreadsheet)
    end

    def spreadsheet_share(spreadsheet_id)
      permission = Google::Apis::DriveV3::Permission.new(type: "anyone", role: "reader")
      @drive_service.create_permission(spreadsheet_id, permission)
    end

    def spreadsheet_update(spreadsheet_id, range, values)
      value_range = Google::Apis::SheetsV4::ValueRange.new(range: range, values: values)
      @sheets_service.update_spreadsheet_value(spreadsheet_id, range, value_range, value_input_option: "RAW")
    end

    def cell_update(spreadsheet_id, requests)
      batch_update_request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: requests)
      @sheets_service.batch_update_spreadsheet(spreadsheet_id, batch_update_request)
    end
  end
end
