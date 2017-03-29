$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'data-sink-client'
require 'webmock/rspec'
WebMock.disable_net_connect!

def gzip(body)
  wio = StringIO.new("w")
  w_gz = Zlib::GzipWriter.new(wio)
  w_gz.write(body)
  w_gz.close
  wio.string
end


