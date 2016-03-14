require_relative 'extractor'

class ExtractorServer
  def call(env)
    request = Rack::Request.new(env)
    params = CGI::parse(request.query_string)

    headers = {'Content-Type' => 'application/json', 'Access-Control-Allow-Origin' => '*' }
    status = 200

    response = {}

    Workers.map(Array(params['urls'])) { |url| puts "STARTING #{url}"; response[url] = Extractor.new(url).extract }

    [status, headers, [response.to_json]]
  # rescue
  #   [500, {'Content-Type' => 'text/plain'}, ["Well this is embarrassing: #{$!.message}."]]
  end
end
