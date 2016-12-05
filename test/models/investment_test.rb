require 'test_helper'

class InvestmentTest < ActiveSupport::TestCase
	investment = Investment.new(5)
  
  test "should calculate compound interest of init investment" do 
	  assert_equal investment.calculateCompundInterest, 40.58
	end
end
