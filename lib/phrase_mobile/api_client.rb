require 'typhoeus'
require 'yaml'

module PhraseMobile
  class ApiClient
    SITE_URL = 'https://phraseapp.com/api/v1'

    attr_accessor :configuration

    def initialize(options = {})
      self.configuration = options.fetch(:configuration)
    end

    def read_translations_for_locale(locale)
      response = Typhoeus::Request.get(build_url_for_path('/translations/download'), build_params(locale: locale))
      if response.success?
        YAML::load(response.body)[locale]
      elsif response.code == 404
        raise TranslationsNotFoundException.new(locale)
      else
        handle_response_error(response)
      end
    end

    def create_translations_for_locale(translations, locale)
      response = Typhoeus::Request.post(build_url_for_path('/translation_keys/upload'),
                                       body: build_params(file_content: { locale => translations }.to_yaml))
      unless response.success?
        handle_response_error(response)
      end
    end

    private

    def handle_response_error(response)
      if response.code == 401
        raise InvalidAuthTokenException
      else
        raise ClientConnectionException
      end
    end

    def build_params(params)
      { auth_token: self.configuration.auth_token }.merge(params)
    end

    def build_url_for_path(path)
      "#{SITE_URL}#{path}"
    end
  end
end
