require_relative 'config/environment'
require_relative 'extractor_server'

app = Rack::Builder.new do
  map '/extract' do
    run ExtractorServer.new
  end
end

run app
