require 'rest-client'
require 'json'

url = "https://footballapi.pulselive.com/football/competitions?page=0&pageSize=100&detail=2"


header = {
    Host: 'footballapi.pulselive.com',
    Connection: 'keep-alive',
    Origin: 'https://www.premierleague.com',
    User-Agent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36',
    Content-Type: 'application/x-www-form-urlencoded; charset=UTF-8',
    Accept: '*/*',
    Referer: 'https://www.premierleague.com/results',
    Accept-Encoding: 'gzip, deflate, br',
    Accept-Language: 'ko,en-US;q=0.9,en;q=0.8',
    If-None-Match: 'W/"08893f9c357923c7b152b995f6b9a24e8"'
}
result=RestClient.get(url, header)

puts result
