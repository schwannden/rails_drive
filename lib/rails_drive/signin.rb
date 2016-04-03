require 'rails_drive/google'

module RailsDrive
  # Alias the module
  Oauth2       = Google::Apis::Oauth2V2
  Auth         = Google::Auth

  class Signin
    include RailsDrive::Config

    def initialize(id_token_string)
      @id_token = id_token_verifier(id_token_string)
    end

    def create_or_get_user
      if @id_token != nil
        user = User.find_by open_id: @id_token.user_id
        if user
          user
        else
          User.create open_id: @id_token.user_id, email: @id_token.email
        end
      end
    end

    private

    def id_token_verifier(id_token_string)
      client_id    = Auth::ClientId.from_file CLIENT_SECRETS_PATH
      auth_service = Oauth2::Oauth2Service.new
      id_token     = auth_service.tokeninfo(id_token: id_token_string)
      begin
        raise 'token not issued to us' if id_token.issued_to != client_id.id
        raise 'token not issued to us' if id_token.audience != client_id.id
        id_token
      rescue Exception => e
        nil
      end
    end

  end
end
