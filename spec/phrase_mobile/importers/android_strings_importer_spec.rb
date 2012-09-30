require 'spec_helper'

describe PhraseMobile::AndroidStringsImporter do
  let(:filename) { 'spec/fixtures/strings.xml' }
  let(:importer) { PhraseMobile::AndroidStringsImporter.new(filename: filename) }
  let(:imported_translations) { { app_name: 'MyTestApp', hello_world: 'Hello world!', menu_settings: 'Settings',
                                  title_activity_main: 'MainActivity', variables_included: 'This is the number: %d',
                                  reordered_variables_included: 'This: %1$s and this: %2$s could be reordered' } }

  it "should pull out the key to translation values from an android strings file" do
    importer.import_to_hash.should == imported_translations
  end

  it "should raise an error when file not found" do
    importer.filename = 'noway.xml'
    expect { importer.import_to_hash }.to raise_error(PhraseMobile::TranslationFileNotFoundException, "The translation file 'noway.xml' was not found")
  end

  it "should raise an error when file not valid" do
    importer.filename = 'spec/fixtures/invalid_file.hmm'
    expect { importer.import_to_hash }.to raise_error(PhraseMobile::ParsingException)
  end
end
