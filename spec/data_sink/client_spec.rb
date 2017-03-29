require 'spec_helper'
require 'faraday'
require 'byebug'

describe DataSink::Client do
  let(:options) { {user: user, pass: pass} }
  let(:user) { 'test-user' }
  let(:pass) { 'test-pass' }
  subject { described_class.new(options) }

  describe 'initialize' do
    it 'creates a client' do
      expect(subject.client).to be_a(Faraday::Connection)
    end

    context 'with a client' do
      let(:client) { double(:client) }
      let(:options) { super().merge(client: client) }

      it 'uses the supplied client' do
        expect(subject.client).to eq(client)
      end
    end
  end

  context 'with stubbed adapter' do
    let(:url)  { 'https://test.dev' }
    let(:base) { 'archives' }
    let(:stream_id) { 'test-stream' }
    let(:endpoint) { "#{base}/#{stream_id}" }
    let(:body) { 'body-content' }
    let(:options) { super().merge(
      url: url,
      endpoint: base
    ) }

    before do
      stub_request(:post, "#{url}/#{endpoint}")
    end


    describe 'post_gzipped' do
      let(:perform) { subject.post_gzipped(stream_id, body) }

      it 'posts the body' do
        perform
        expect(WebMock).to have_requested(:post, "#{url}/#{endpoint}").
          with(body: body, headers: {'Content-Encoding' => 'application/gzip'})
      end
    end

    describe 'post' do
      let(:compressed_body) { gzip(body) }

      let(:perform) { subject.post(stream_id, body) }

      it 'posts the body' do
        perform
        expect(WebMock).to have_requested(:post, "#{url}/#{endpoint}").
          with(body: compressed_body, headers: {'Content-Encoding' => 'application/gzip'})
      end
    end
  end
end
