require 'libxml'

module PhraseMobile
  class AndroidStringsExporter
    attr_accessor :filename

    class << self
      def hash_to_file(filename, translations)
        self.new(filename: filename).export_from_hash(translations)
      end
    end

    def initialize(options = {})
      self.filename = options.fetch(:filename)
    end

    def export_from_hash(translations)
      doc = LibXML::XML::Document.new()
      doc.root = translations.inject(LibXML::XML::Node.new('resources')) do |root, (key, translation)|
        node = LibXML::XML::Node.new('string', translation)
        node['name'] = key.to_s
        root << node
        root
      end
      doc.save(filename, :indent => true, :encoding => LibXML::XML::Encoding::UTF_8)
    end
  end
end
