Company.create(name: "S&P 500", symbol: "SPX")

stockTradingActivity = #data from snp.json
stockTradingActivity.each do |record|
	date = record[0]
	open = record[1]
	high = record[2]
	low = record[3]
	close = record[4]
	volume = record[5]

  StockTradingActivity.create(date: date, open: open, high: high, low: low, close: close, volume: volume, company_id: 1)
end
