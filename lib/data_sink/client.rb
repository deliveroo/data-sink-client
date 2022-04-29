require 'faraday'

module DataSink
  class Client
    DEFAULTS = {
      url: '',
      endpoint: '/archives',
      retry_max: 2,
      retry_interval: 0.1,
      retry_backoff_factor: 2,
      adapter: :excon,
      read_timeout: 5,
      open_timeout: 5,
      add_newlines: true
    }.freeze

    attr_reader :client, :options

    def initialize(options={})
      @options = DEFAULTS.merge(options)
      user = @options.fetch(:user)
      pass = @options.fetch(:pass)
      @client = options[:client] || create_client(user, pass)
    end

    def post(stream_id, body, partition_key: nil)
      post_gzipped(stream_id, gzip(transform(body)), partition_key: partition_key)
    end

    def post_gzipped(stream_id, body, partition_key: nil)
      client.post do |req|
        req.url endpoint(stream_id, partition_key)
        req.body = body
      end
    end

    private

    def endpoint(stream_id, partition_key)
      path = [options[:endpoint], stream_id].join('/')
      partition_key.nil? ? path : "#{path}?partition_key=#{partition_key}"
    end

    def create_client(user, pass)
      Faraday.new(options[:url], ssl: { verify: true }) do |f|
        f.headers['Content-Encoding'] = 'application/gzip'
        f.headers['Content-Type'] = 'application/octet-stream'
        f.request :retry, methods: [:post], max: options[:retry_max], interval: options[:retry_interval], backoff_factor: options[:retry_backoff_factor]
        f.options.timeout = options[:read_timeout] if options[:read_timeout]
        f.options.open_timeout = options[:open_timeout] if options[:open_timeout]
        f.adapter options[:adapter]
      end.tap do |client|
        client.request(:basic_auth, user, pass)
      end
    end

    def transform(body)
      if options[:add_newlines]
        body + "\n"
      else
        body
      end
    end

    def gzip(body)
      wio = StringIO.new("w")
      w_gz = Zlib::GzipWriter.new(wio)
      w_gz.write(body)
      w_gz.close
      wio.string
    end
  end
end
