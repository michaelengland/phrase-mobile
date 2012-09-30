require 'typhoeus'
require 'yaml'

module PhraseMobile
  class ApiClient
    SITE_URL = 'https://phraseapp.com/api/v1'

    attr_accessor :configuration

    def initialize(options = {})
      self.configuration = options.fetch(:configuration)
    end

    def translations_for_locale(locale)
      response = Typhoeus::Request.get(translations_url_for_locale(locale))
      if response.success?
        YAML::load(response.body)[locale]
      elsif response.code == 404
        raise TranslationsNotFoundException.new(locale)
      elsif response.code == 401
        raise InvalidAuthTokenException
      else
        raise ClientConnectionException
      end
    end

    private

    def translations_url_for_locale(locale)
      build_url_for_path_and_params('/translations/download', locale: locale)
    end

    def build_url_for_path_and_params(path, additional_params)
      "#{SITE_URL}#{path}?#{params_string({ auth_token: self.configuration.auth_token }.merge(additional_params))}"
    end

    def params_string(params = {})
      params.map { |k, v| "#{k}=#{v}" }.join('&')
    end
  end
end
