require 'spec_helper'

describe PhraseMobile::ApiClient do
  let(:configuration) { PhraseMobile::Configuration.new(auth_token: '12345abcde' ) }
  let(:client) { PhraseMobile::ApiClient.new(configuration: configuration) }
  let(:response) { double(success?: true, code: 200, body: File.read('spec/fixtures/translations.yml')) }
  let(:translations) { { 'app_name' => 'MyTestApp', 'hello_world' => 'Hello world!', 'menu_settings' => 'Settings',
                         'title_activity_main' => 'MainActivity', 'variables_included' => 'This is the number: %d',
                         'reordered_variables_included' => 'This: %1$s and this: %2$s could be reordered' } }

  describe "#read_translations_for_locale" do
    it "retrieves a translation hash from the servers yaml representation of translations for a locale" do
      Typhoeus::Request.stub(:get) { response }
      client.read_translations_for_locale('en-GB').should == translations
    end

    it "retrieves translations from the correct server yaml" do
      Typhoeus::Request.should_receive(:get).with('https://phraseapp.com/api/v1/translations/download',
                                                  { auth_token: '12345abcde', locale: 'en-GB' }) { response }
      client.read_translations_for_locale('en-GB')
    end

    it "raises an error when the given locale doesn't exists" do
      Typhoeus::Request.stub(:get) { double(success?: false, code: 404, body: '') }
      expect { client.read_translations_for_locale('en-GB') }.to raise_error(PhraseMobile::TranslationsNotFoundException,
                                                                        "The locale 'en-GB' was not found")
    end

    it "raises an error when the given auth token is invalid" do
      Typhoeus::Request.stub(:get) { double(success?: false, code: 401, body: '') }
      expect { client.read_translations_for_locale('en-GB') }.to raise_error(PhraseMobile::InvalidAuthTokenException)
    end

    it "raises an error when some other error occurred" do
      Typhoeus::Request.stub(:get) { double(success?: false, code: 500, body: '') }
      expect { client.read_translations_for_locale('en-GB') }.to raise_error(PhraseMobile::ClientConnectionException)
    end
  end

  describe "#create_translations_for_locale" do
    it "sends translations to the server via yaml" do
      Typhoeus::Request.should_receive(:post).with('https://phraseapp.com/api/v1/translation_keys/upload',
                                                   body: { auth_token: '12345abcde',
                                                           file_content: { 'en-GB' => translations }.to_yaml }) { response }
      client.create_translations_for_locale(translations, 'en-GB')
    end

    it "raises an error when the given auth token is invalid" do
      Typhoeus::Request.stub(:post) { double(success?: false, code: 401, body: '') }
      expect { client.create_translations_for_locale(translations, 'en-GB') }.to raise_error(PhraseMobile::InvalidAuthTokenException)
    end

    it "raises an error when some other error occurred" do
      Typhoeus::Request.stub(:post) { double(success?: false, code: 500, body: '') }
      expect { client.create_translations_for_locale(translations, 'en-GB') }.to raise_error(PhraseMobile::ClientConnectionException)
    end
  end
end
