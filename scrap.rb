require 'rest-client'
require 'json'

url ="http://webtoon.daum.net/data/pc/webtoon/list_daily_ranking/finished?timeStamp=1510903239849"
result = RestClient.get url
result=JSON.parse(result)
# puts result
# puts result.class


result['data'].each do |data|
  #puts data.keys
  artist = data['cartoon']['artists'].collect {|artist| artist["name"]}
  title = data['title']
  score = data['averageScore'].round(1)
  image_url = data['appThumbnailImage']['url']
  # puts image_url
  # puts score
  # puts title

  puts "#{title}(#{artist}) / #{score}, image :#{image_url}"
  #puts artist
end
