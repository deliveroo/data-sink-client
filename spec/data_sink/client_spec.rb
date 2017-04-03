require 'spec_helper'
require 'faraday'

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
      endpoint: base,
      retry_max: 2
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

      context 'with two timeouts' do
        before do
          stub_request(:post, "#{url}/#{endpoint}")
            .to_timeout.to_timeout
            .to_return(status: 200)
        end

        it 'succeeds after 2 tries' do
          expect { perform }.to_not raise_error
          assert_requested :post, "#{url}/#{endpoint}", body: body, times: 3
        end
      end

      context 'with three timeouts' do
        before do
          stub_request(:post, "#{url}/#{endpoint}")
            .to_timeout.to_timeout.to_timeout
            .to_return(status: 200)
        end

        it 'fails after 3 tries' do
          expect { perform }.to raise_error(Faraday::TimeoutError)
          assert_requested :post, "#{url}/#{endpoint}", body: body, times: 3
        end
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
