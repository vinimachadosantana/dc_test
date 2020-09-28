require 'json'
require 'net/http'
require './processing'

class Payload < Processing
  URL = URI('https://delivery-center-recruitment-ap.herokuapp.com/').freeze

  def call(payload)
    response = setup_connection.request(make_request(payload.to_json))

    response
  end

  private

  def make_request(body)
    request = Net::HTTP::Post.new(URL.path)
    request['Content-Type'] = 'application/json'
    request['X-sent'] = Time.now.strftime("%Hh%M - %d/%m/%y")
    request.body = body
    
    request
  end

  def setup_connection
    Net::HTTP.new(URL.host, URL.port)
  end
end

Payload.new.call(Processing.new.call(JSON.parse(File.read('payload.json'))))