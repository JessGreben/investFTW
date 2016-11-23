class Investment < ApplicationRecord
	attr_reader :investedValue

	def initialize(initInvestment)
		@initInvestment = initInvestment.to_f
		@compoundFrequency = 12.0
		@time = 30.0
		@interestRate = 0.07
		@investedValue = 0.0
	end

	def calculateCompundInterest
		@investedValue = @initInvestment * (1+ @interestRate/@compoundFrequency) ** (@compoundFrequency*@time) 
		return @investedValue.round(2)
	end
end