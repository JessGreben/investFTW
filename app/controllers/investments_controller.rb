class InvestmentsController < ApplicationController
	def new
		@stock_activity = StockTradingActivity.new
		render
	end

	def create
		@initInvest = params["initInvestment"]
		@investment = Investment.new(@initInvest)
		@initInvestment = @initInvest
		render
	end
end
