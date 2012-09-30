module PhraseMobile
  class TranslationFileNotFoundException < StandardError
    def initialize(filename)
      super("The translation file '#{filename}' was not found")
    end
  end
  class ParsingException < StandardError; end
end
