module PhraseMobile
  class Configuration
    attr_accessor :auth_token

    def initialize(options = {})
      self.auth_token = options.fetch(:auth_token)
    end
  end
end
