class InvestmentsController < ApplicationController
	def new
		@stock_activity = StockTradingActivity.new
		render
	end

	def create
		@investment = Investment.new(investment_params[:init])
	end

	private
	
	def investment_params
		params.require(:investment).permit(:init)
	end
end
