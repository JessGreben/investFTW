class InvestmentsController < ApplicationController
	def new
	end

	def create
		@initInvest = params["initInvestment"]
		@investment = Investment.new(@initInvest)
		@initInvestment = @initInvest
		render
	end
end
