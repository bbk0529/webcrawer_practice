require 'nokogiri'
require 'rest-client'

url = 'http://ticket.melon.com/csoon/ajax/listTicketOpen.htm'
params = {
  "orderType" =>2,
  "pageIndex" =>1,
  "schText" =>''
}

puts RestClient.post(url,params)
