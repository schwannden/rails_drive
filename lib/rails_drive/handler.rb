require 'fileutils'
require 'rails_drive/google'

module RailsDrive

  class Handler

    include RailsDrive::Config
    # Alias the module
    Oauth2 = Google::Apis::Oauth2V2
    Auth   = Google::Auth

    attr_reader :credentials, :auth_client

    def initialize(user_id = 'default')
      # Token store
      FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
      client_id    = Auth::ClientId.from_file CLIENT_SECRETS_PATH
      token_store  = Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      @user_id     = user_id
      # credentials
      @authorizer  = Auth::UserAuthorizer.new(client_id, SCOPE, token_store, CALLBACK_URI)
      @credentials = @authorizer.get_credentials(@user_id)
      # serive
      @service     = Google::Apis::DriveV3::DriveService.new
      @service.client_options.application_name = 'seo-report'
      @service.authorization = @credentials
    end

    def get_authorization_url
      @authorizer.get_authorization_url base_url: BASE_URL
    end

    def get_and_store_credentials_from_code(code)
      @credentials = @authorizer.get_and_store_credentials_from_code(
        user_id: @user_id, code: code, base_url: BASE_URL)
      @service.authorization = @credentials
    end

    def list_files(options={})
      # List files under a folder
      conditions = []
      conditions << "'#{options[:folder]}' in parents" if options.has_key? :folder
      conditions << "name = '#{options[:file_name]}'" if options.has_key? :file_name
      options = {
        q: conditions.join(" and "),
        spaces: 'drive',
        fields:'nextPageToken, files(id, name, webViewLink)'
      }
      @service.list_files options
    end

    def get_folder(name)
      options = {
        q: "mimeType='application/vnd.google-apps.folder' and name='#{name}'",
        spaces: 'drive',
        fields:'nextPageToken, files(id, name, webViewLink)'
      }
      @service.list_files options
    end

    def has_credentials?
      @credentials
    end

  end

end
