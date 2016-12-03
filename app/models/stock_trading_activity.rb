class StockTradingActivity < ApplicationRecord
	include HTTParty
	belongs_to :company

	def find_date_of_last_stock_update
		most_recent_stock_activity_date = StockTradingActivity.select(:date).order(:date).last
		return most_recent_stock_activity_date[:date]
	end

	def get_recent_stock_activity_data_for_snp
		recentStockData = Hash.new
		most_recent_stock_activity_date = self.find_date_of_last_stock_update
		yesterday_date = Date.yesterday

		if most_recent_stock_activity_date != yesterday_date
			dataset = quandle_api_call(most_recent_stock_activity_date)
			last_updated_at = DateTime.parse(dataset["refreshed_at"]).strftime("%m/%d/%Y %I:%M")
			recentStockData["daily_activity_data"] = dataset["data"]
			recentStockData["last_updated_at"] = last_updated_at
			return recentStockData
		end
		recentStockData["last_updated_at"] = most_recent_stock_activity_date
		return recentStockData
	end

	def quandle_api_call(start_date)
		key = ENV["QUANDL_API_KEY"]
		uri = "https://www.quandl.com/api/v3/datasets/YAHOO/INDEX_GSPC.json?api_key=#{key}&start_date=#{start_date}"
		response = HTTParty.get(uri, :headers =>{'Content-Type' => 'application/json'})
		body = JSON.parse(response.body)
		dataset = body["dataset"]
		dataset
	end

	def update_recent_stock_activity_data(companyId = 1)
		recentStockData = self.get_recent_stock_activity_data_for_snp

		if recentStockData.length > 1
			recentStockData["daily_activity_data"].each do |daily_stock_activity| 
				date = daily_stock_activity[0]
				open = daily_stock_activity[1]
				high = daily_stock_activity[2]
				low = daily_stock_activity[3]
				close = daily_stock_activity[4]
				volume = daily_stock_activity[5]	
			  StockTradingActivity.create!(date: date, open: open, high: high, low: low, close: close, volume: volume, company_id: companyId)
			end
		end
		return recentStockData["last_updated_at"]
	end

	def get_last_day_close
		last_day_close = StockTradingActivity.select(:close).order(:date).last
		last_day_close.close
	end

	def get_day_before_last_close
		last_day_date = self.find_date_of_last_stock_update
		day_before_last_date = last_day_date - 1.day
		day_before_last_date_close = StockTradingActivity.select(:close).where("date = '#{day_before_last_date}'").first
		day_before_last_date_close.close
	end

	def get_last_day_change
		last_close = get_last_day_close
		day_before_last_close = get_day_before_last_close
		
		change = last_close - day_before_last_close

		if change > 0
			return "+ #{change}"
		else
			return	"#{change}"
		end
	end
end
