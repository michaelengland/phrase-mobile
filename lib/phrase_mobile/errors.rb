module PhraseMobile
  class PhraseMobileException < StandardError; end
  class TranslationFileNotFoundException < PhraseMobileException
    def initialize(filename)
      super("The translation file '#{filename}' was not found")
    end
  end
  class ParsingException < PhraseMobileException; end
  class ClientConnectionException < PhraseMobileException; end
  class InvalidAuthTokenException < PhraseMobileException; end
  class TranslationsNotFoundException < PhraseMobileException
    def initialize(locale)
      super("The locale '#{locale}' was not found")
    end
  end
end
