class InvestmentsController < ApplicationController
	def new
		uri = "https://www.quandl.com/api/v3/datasets/YAHOO/INDEX_GSPC.json?api_key=#{QUANDL_API_KEY}&start_date=2016-11-20"
		response = HTTParty.get(uri, :headers =>{'Content-Type' => 'application/json'})
		body = JSON.parse(response.body)
		dataset = body["dataset"]
		d = DateTime.parse(dataset["refreshed_at"]).strftime("%m/%d/%Y %I:%M")
		@updatedAt = d
		@yesterdayClose = dataset["data"][0][4]
		render
	end

	def create
		@initInvest = params["initInvestment"]
		@investment = Investment.new(@initInvest)
		@initInvestment = @initInvest
		render
	end
end
