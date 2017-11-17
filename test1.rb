require 'rest-client'
require 'json'

url = "https://watcha.net/boxoffice.json?page=1&per=19"




header = {
   cookie: "__uvt=; _s_guit=f8e29ab43be25368fe8d1aeb46bd2d97b759a256b4065510e3726b27f704; _gat=1; uvts=6m4UIAwswTiQHSqM; _guinness_session=R09ja2JwSCtwVUFEQitORDVaZHZQSzluVHRkdStyMzlVblU5R1BiZlBycjJlREVuTGFGd3REYlUxVFc1WWVrVGMvOWdubUp3anQ4c1JKUVRQNWtvaXBIV3JiZC84anBWRTlRV1phYjVIK3Jrb2picUNIdEtYZDVXVVNqQkY3VnJvMXlCZVczUXVjb0F5WXFUR3NtWXRLa1IxcklLUks1OEhpQTJDbVpnTVk0UC8xalFsRW55NkZIQW9Zb0ZpTEFrcEQxejNEM0hab3p6VHJVUEIvN3RKQWhiMlZ5REhOblBLWG44UFliZmlpVT0tLTZrTGpDcnYzOUxaQ1pGT2xqRUk3WXc9PQ%3D%3D--cb3a39e4d6f717be537af828da43bb7acead13c4; _ga=GA1.2.949273064.1510904452; _gid=GA1.2.245577263.1510904452"

 }
result=RestClient.get(url,header)

puts result
