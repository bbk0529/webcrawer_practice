require 'rest-client'
require 'json'


header = {
    "Accept": "application/json",
    "Cookie": "_ga=GA1.2.1708517726.1510532865; webid=FQhHyiLqhxA1/2x8JKjZxI8/kO/a1Bv8wi6QhkcU8RbozHYVwGK+iRRyrh77VB5d; kuid=348066915626778650; TIARA=mkjzLFufkpod7USFhW8dQH1By9bv1NhCye9kz5u71XzGHkgeRR73MjYAUGJFwWvnGS.-7UFPYI_._Sb5tZvej9kHyZey7HOf; _kawlt=GZN1iVLMB8LKT2uWTULPoGReQ7GJFKoJjTs2UphII-F9aRLepV3ug-cwFJ8GIHLuZmVE3a9OQ_ImJ7LVidCZCcR4KBk1VG2wmuiqJhSsHXA; _karmt=gHx_xAME3OcEsDK4XxZVXY-DJMlaL36M-6Bp-k4YEPM2K9iJ1zRB__RIAzxTjZlc; _kawltea=1511066288; _karmtea=1511077088; _gplat=1510990696165",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36"
}




total={}
array=['정세원', '훈', '김종진', '옥승민', '여임규', '박병규 BK PARK', '송문호', '이유동']
array.each  {|arr| total[arr]=[]}



array.each do |arr|
    query = URI.escape(arr)
    i=0
    while (true) do
        url = "https://group.kakao.com/wapi/api/search/activities?group_id=_kjOlOM&query=#{query}&last_seq=#{20*i}&_=1510992329379"
        result=JSON.parse(RestClient.get(url, header))

        result['activities'].each do |activity|
            id= activity['id']
            content=activity['content']
            date=activity['created_at']

            content=content[24,content.size-24-3]
            if content.nil? then content='' end
            content.gsub!('\\n','')

            if total[arr]
                total[arr].push([date,content])
            else
                total[arr]=[date,content]
            end
            #puts arr + "says  " + content

            if activity['comment_count']>0
                comment_url = "https://group.kakao.com/wapi/activities/#{id}/comments?before=&_=1510993592833"
                comment_result=JSON.parse(RestClient.get(comment_url, header))

                comment_result['comments'].each do |comment|
                    writer=comment['writer']['name']
                    date=comment['created_at']
                    if comment['decorators']
                        text=comment['decorators'][0]['text']
                        if total[writer]
                            total[writer].push([date,text])
                        else
                            total[writer]=[[date,text]]
                        end #end of total['writer']
                        #puts writer +"says  " + text
                    end #end of comment['decorators']
                end # end of comment_result['comment']

            end # end of acvitieis['comment_count']

        end #end of result['activities']
        p "currently with " + arr + "No. " + i.to_s + " out of " + (result['total_count']/20).to_s
        break if i >= (result['total_count'] / 20)

        i +=1
    end # end of while(true)

end #end of array.each
