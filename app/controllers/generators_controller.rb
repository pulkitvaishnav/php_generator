class GeneratorsController < ApplicationController
	include GeneratorsHelper
	def index
		@generator= Generator.new
		$/ = "</form>" 						
		user_input = @generator
		user_input = user_input.try(:split, "\n")
		view_context.splitter(user_input)
		return user_input
	end
end
