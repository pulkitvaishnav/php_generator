module GeneratorsHelper
	def splitter(user_input)
		input_array = Array.new
		user_input.each do |i|
			each_element = i.split(/[<>\s]/)
			input_array.push each_element
		end
		return input_array
		
	end

end
