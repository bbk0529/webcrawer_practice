require 'rest-clientjson'
require 'nokogiri'
require 'json'


class Crawer
  def self.html(url, action, params)

    (send_request(action, url, params))
  end

  def self.json(url, action, params)
    JSON.parse(send_request(action, url, params))
  end
  private
  def self.send_request(action, url, params)
    RestClient.send(action,url,params)
  end
end
