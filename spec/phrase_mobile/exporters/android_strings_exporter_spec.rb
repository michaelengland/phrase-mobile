require 'spec_helper'

describe PhraseMobile::AndroidStringsExporter do
  let(:filename) { 'test.xml' }
  let(:exporter) { PhraseMobile::AndroidStringsExporter.new(filename: filename) }
  let(:translations) { { app_name: 'MyTestApp', hello_world: 'Hello world!', menu_settings: 'Settings',
                         title_activity_main: 'MainActivity', variables_included: 'This is the number: %d',
                         reordered_variables_included: 'This: %1$s and this: %2$s could be reordered' } }

  after do
    begin
      File.delete(filename)
    rescue
    end
  end

  it "should write the key and translation pairs to an android strings file" do
    exporter.export_from_hash(translations)
    File.read(filename).should == File.read('spec/fixtures/strings.xml')
  end

  it "should override any existing translations" do
    File.open(filename, 'w') do |f|
      f.write("I think you'll find there's already something here!")
    end
    exporter.export_from_hash(translations)
    File.read(filename).should == File.read('spec/fixtures/strings.xml')
  end
end
