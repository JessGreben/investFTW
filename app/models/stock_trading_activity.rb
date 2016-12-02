class StockTradingActivity < ApplicationRecord
	include HTTParty
	belongs_to :company

	def find_date_of_last_stock_update
		most_recent_stock_activity = StockTradingActivity.select(:date).order(:date).last
		return most_recent_stock_activity[:date]
	end

	def get_recent_stock_activity_data_for_snp
		recentStockData = Hash.new
		key = ENV["QUANDL_API_KEY"]
		most_recent_stock_activity_update_date = self.find_date_of_last_stock_update
		yesterday_date = Date.yesterday
		
		# if start date is not yesterday, then make this api call
		if most_recent_stock_activity_update_date != yesterday_date
			uri = "https://www.quandl.com/api/v3/datasets/YAHOO/INDEX_GSPC.json?api_key=#{key}&start_date=#{most_recent_stock_activity_update_date}"
			response = HTTParty.get(uri, :headers =>{'Content-Type' => 'application/json'})
			body = JSON.parse(response.body)
			dataset = body["dataset"]
			last_updated_at = DateTime.parse(dataset["refreshed_at"]).strftime("%m/%d/%Y %I:%M")

			recentStockData["daily_activity_data"] = dataset["data"]
			recentStockData["last_updated_at"] = last_updated_at
			return recentStockData
		end
		recentStockData["last_updated_at"] = most_recent_stock_activity_update_date
		return recentStockData
	end

	def update_recent_stock_activity_data(companyId = 1)
		recentStockData = self.get_recent_stock_activity_data_for_snp

		while recentStockData.length > 1
			recentStockData.each do |daily_stock_activity| 
				date = daily_stock_activity[0]
				open = daily_stock_activity[1]
				high = daily_stock_activity[2]
				low = daily_stock_activity[3]
				close = daily_stock_activity[4]
				volume = daily_stock_activity[5]	
			  StockTradingActivity.create(date: date, open: open, high: high, low: low, close: close, volume: volume, company_id: companyId)
		  return recentStockData["last_updated_at"]
			end
		end
		return recentStockData["last_updated_at"]
	end

	# def get_yesterday_close(companyId: 1)
	# 	yesterday_close = StockTradingActivity.select(:close).order(:date).last
	# 	yesterday_close
	# end

	# def get_yesterday_change(companyId: 1)
	# 	yesterday_close = yesterday_close
	# 	day_before_yesterday_close = dby_close 
	# 	change = yesterday_close - day_before_yesterday_close
	# 	if change > 0
	# 		return "+ #{change}"
	# 	else
	# 		return	"- #{change}"
	# 	end
	# end
end
