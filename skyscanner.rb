require 'rest-client'
require 'json'
require 'nokogiri'
require 'time'
require 'active_support'
require 'active_support/core_ext'
require 'csv'
require 'awesome_print'

def search(dk,k,search_start, search_end, period_start, period_finish, limit, result)
	array1=[]
	array2=[]
	min1=[]
	min2=[]
    (period_start..period_finish).to_a.each do |period|
        (search_start..search_end).to_a.each do |j|
            break if (j+period) >= search_end
            outbound = result['PriceGrids']['Grid'][0][j-1]['DirectOutboundPrice']
            inbound = result['PriceGrids']['Grid'][j-1+period][j-1]['DirectInboundPrice']

            outbound2 = result['PriceGrids']['Grid'][0][j-1]['IndirectOutboundPrice']
            inbound2 = result['PriceGrids']['Grid'][j-1+period][j-1]['IndirectInboundPrice']

            p "            " +"direct" + j.to_s + "일 부터 " + (j+period).to_s + "일 까지 " + period.to_s + "일 동안 " + (outbound + inbound).to_s + "원입니다" if  outbound && inbound && ((inbound + outbound) < limit)
            p "            " +"Indirect" + j.to_s + "일 부터 " + (j+period).to_s + "일 까지 " + period.to_s + "일 동안 " + (outbound2 + inbound2).to_s + "원입니다" if  outbound2 && inbound2 && ((inbound2 + outbound2) < limit)
			
			CSV.open("file.csv", "a+") do |csv|
				if  outbound && inbound && ((inbound + outbound) < limit)
					csv << [dk,k, "direct", j, j+period, period, (outbound + inbound)] 
					array1.push([dk,k,"direct",j,j+period, period, (outbound+inbound)])
					min1.push(outbound+inbound)
				end

				if  outbound2 && inbound2 && ((inbound2 + outbound2) < limit)
	  				csv << [dk,k, "indirect", j, j+period, period, (outbound2+outbound2)] 
					array2.push([dk,k,"indirect",j,j+period, period, (outbound2+inbound2)])
					min2.push(outbound2+inbound2)
				end
			
			end

        end
    end
    ap array1[min1.index(min1.min)] if min1.size!=0
    ap array2[min2.index(min2.min)] if min2.size!=0
end


#url = 'https://www.skyscanner.co.kr/dataservices/browse/v3/mvweb/KR/KRW/ko-KR/calendar/SELA/HAN/2017-12/2017-12/?profile=minimalmonthviewgrid&abvariant=GDT1606_ShelfShuffleOrSort:b|GDT1606_ShelfShuffleOrSort_V5:b|RTS2189_BrowseTrafficShift:b|RTS2189_BrowseTrafficShift_V8:b|rts_mbmd_anylegs:b|rts_mbmd_anylegs_V5:b|GDT1693_MonthViewSpringClean:b|GDT1693_MonthViewSpringClean_V13:b|GDT2195_RolloutMicroserviceIntegration:b|GDT2195_RolloutMicroserviceIntegration_V4:b'
#url = 'https://www.skyscanner.co.kr/dataservices/browse/v3/mvweb/KR/KRW/ko-KR/calendar/SELA/HAN/2017-12/2018-01/?profile=minimalmonthviewgrid&abvariant=GDT1606_ShelfShuffleOrSort:b|GDT1606_ShelfShuffleOrSort_V5:b|RTS2189_BrowseTrafficShift:b|RTS2189_BrowseTrafficShift_V8:b|rts_mbmd_anylegs:b|rts_mbmd_anylegs_V5:b|GDT1693_MonthViewSpringClean:b|GDT1693_MonthViewSpringClean_V13:b|GDT2195_RolloutMicroserviceIntegration:b|GDT2195_RolloutMicroserviceIntegration_V4:b'


headers = {
    #":authority":"www.skyscanner.co.kr",
    #":method":"GET",
    #":path":"/dataservices/browse/v3/mvweb/KR/KRW/ko-KR/calendar/SELA/HAN/anytime/anytime/?profile=minimalmonthviewgrid&abvariant=GDT1606_ShelfShuffleOrSort:b|GDT1606_ShelfShuffleOrSort_V5:b|RTS2189_BrowseTrafficShift:b|RTS2189_BrowseTrafficShift_V8:b|rts_mbmd_anylegs:b|rts_mbmd_anylegs_V5:b|GDT1693_MonthViewSpringClean:b|GDT1693_MonthViewSpringClean_V13:b|GDT2195_RolloutMicroserviceIntegration:b|GDT2195_RolloutMicroserviceIntegration_V4:b",
    #":scheme":"https",
    #"accept":"*/*",
    #"accept-encoding":"gzip, deflate, br",
    #"accept-language":"ko,en-US;q=0.9,en;q=0.8",
    #"referer":"https://www.skyscanner.co.kr/transport/flights/sela/han/cheap-flights-from-seoul-to-hanoi.html?adults=2&children=0&adultsv2=2&infants=0&cabinclass=economy&rtn=1&preferdirects=false&outboundaltsenabled=false&inboundaltsenabled=false&oym=1712&iym=1712&qp_prevProvider=ins_browse&qp_prevCurrency=KRW&priceSourceId=b3ms-HK1-2&qp_prevPrice=207415&selectedoday=18&selectediday=30",
    "user-agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36"
}


s_date='2017-12-16'
e_date='2017-12-31'
period_start=8
period_finish=15 	
limit=1000000

destination={}
departure={}




#destination["DENPAS"]= "DPS"
#destination["PHNOMPEHN"]= "PNH"
#destination["Siem Reap"]="REP"
#destination.merge!({"방콕": 'BKK', "치앙마이": "CNX", "하노이": 'HAN', "하이퐁": 'HPH', "양곤": 'RGN', "Natra": "CXR", "Laos": "VTE", "luanprabang": "LPQ"})
#destination.merge!({"하노이": 'HAN', "하이퐁": 'HPH', "양곤": 'RGN', "세부": 'CEB', "보라카이": 'KLO'})
#destination.merge!({"뉴욕": 'JFK'})
#destination.merge!({"바르셀로나": 'BCN', "로스엔젤레스": 'LAX', "PERTH": 'PER'})
destination.merge!({"시드니": "SYD"})
#destination.merge!({"HAWAI": "HNL"})
#destination.merge!({"MALE": "MLE", "KOTIKINABALU": "BKI"})
#detination.merge!({"방콕": 'BKK'})
#{}"SAIPAN": "SPN", 


departure["SEOUL"] ="SELA"
departure["BUSAN"] ="PUSA"


ps_date = Date.parse(s_date)
pe_date = Date.parse(e_date)
month_duration =  (pe_date.year - ps_date.year) * 12 + (pe_date.month - ps_date.month) + 1
p departure
p destination


month_duration.times do |i|
    start_month = ps_date.to_s[0,7]

    departure.each do |dk,dv|
	    p '='*30
	    	p "Departure from" + dk.to_s 
	    destination.each do |k,v|
			 
	        url = "https://www.skyscanner.co.kr/dataservices/browse/v3/mvweb/KR/KRW/ko-KR/calendar/#{dv}/#{v}/#{start_month}/#{start_month}/?profile=minimalmonthviewgrid&abvariant=GDT1606_ShelfShuffleOrSort:b|GDT1606_ShelfShuffleOrSort_V5:b|RTS2189_BrowseTrafficShift:b|RTS2189_BrowseTrafficShift_V8:b|rts_mbmd_anylegs:b|rts_mbmd_anylegs_V5:b|GDT1693_MonthViewSpringClean:b|GDT1693_MonthViewSpringClean_V13:b|GDT2195_RolloutMicroserviceIntegration:b|GDT2195_RolloutMicroserviceIntegration_V4:b"
	        #url = "https://www.skyscanner.co.kr/dataservices/browse/v3/mvweb/KR/KRW/ko-KR/calendar/PUSA/#{v}/#{start_month}/#{start_month}/?profile=minimalmonthviewgrid&abvariant=GDT1606_ShelfShuffleOrSort:b|GDT1606_ShelfShuffleOrSort_V5:b|RTS2189_BrowseTrafficShift:b|RTS2189_BrowseTrafficShift_V8:b|rts_mbmd_anylegs:b|rts_mbmd_anylegs_V5:b|GDT1693_MonthViewSpringClean:b|GDT1693_MonthViewSpringClean_V13:b|GDT2195_RolloutMicroserviceIntegration:b|GDT2195_RolloutMicroserviceIntegration_V4:b"
	        result=JSON.parse(RestClient.get(url, headers))
	        search_start=17
	        search_end=ps_date.end_of_month.day
	        p "            " + k.to_s + ' ' + v.to_s + ' ' +start_month
	        search(dk,k,search_start, search_end, period_start, period_finish, limit, result)
	    end
	end
    ps_date = (((ps_date +1) >> 1 ) - 1)
end
