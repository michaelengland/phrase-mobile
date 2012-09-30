require 'libxml'

module PhraseMobile
  class AndroidStringsImporter
    attr_accessor :filename

    class << self
      def hash_from_file(filename)
        self.new(filename: filename).import_to_hash
      end
    end

    def initialize(options = {})
      self.filename = options.fetch(:filename)
    end

    def import_to_hash
      check_file
      string_elements.inject({}) do |h, string_element|
        h[string_element[:name].to_sym] = string_element.content
        h
      end
    rescue LibXML::XML::Error => e
      raise ParsingException.new(e)
    end

    private

    def check_file
      unless File.exist?(self.filename)
        raise TranslationFileNotFoundException.new(filename)
      end
    end

    def string_elements
      document.find('/resources/string')
    end

    def document
      @document ||= begin
        LibXML::XML::Document.file(filename)
      end
    end
  end
end
