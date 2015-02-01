module ApplicationHelper
	def input_query(counter, value_of_attribute, radiocounter, database_name, table_name, database_attr)
			if database_name.to_s.length > 0
				intial_query = "INSERT INTO `#{database_name}`.`#{table_name}`"
			else
				intial_query = "INSERT INTO `<database_name>`.`<table_name>`"
			end
			no_of_attribute = "("
			no_of_attribute = attributes_name(database_name, table_name, database_attr, counter, radiocounter, no_of_attribute)
			no_of_attribute = no_of_attribute + ") "
			values_for_attributes = "VALUES("
			len = value_of_attribute.length
			for i in 0..len - 1
				if i < len - 1
					values_for_attributes = values_for_attributes + "'$#{value_of_attribute[i]}', "
				else
					values_for_attributes = values_for_attributes + "'$#{value_of_attribute[i]}'"
				end
			end
			#no_of_attribute = attributes_name(database_name, table_name, database_attr, counter, no_of_attribute)
			values_for_attributes = values_for_attributes + ");"
			return sql = "\t\t$sql = " + intial_query + no_of_attribute + values_for_attributes
			
	end
	def get_attributes(counter, value_of_attribute, input_array)
		radiocounter = 0
		input_array.each do |each_element|
			name = each_element.select{|type| type.match(/name=.*/)}
			if name.length >= 1
				name = name.to_s.slice(9 .. -5)
				if each_element.select{|type| type.match(/name=radio.*/)}
					radiocounter = radiocounter + 1
				end
				if !(name .eql? "submit")
					value_of_attribute.push name
					@output_array.push "\t\t$#{name} = $_POST['#{name}'];"	
					counter = counter + 1
				else
				 	break
			 	end
			end
		end
		return @output_array, counter, value_of_attribute, radiocounter
	end
	def attributes_name(database_name, table_name, database_attr, counter, radiocounter, no_of_attribute)
	 	if database_name.to_s.length > 0
	 		database_attr.to_s.try(:split, ",").each_with_index do |element, index|

	 			if index < counter-1 && radiocounter<2
	 				no_of_attribute = no_of_attribute + "`#{element}`, "
	 			else
	 				if radiocounter>2
	 					next	
	 				end
	 				no_of_attribute = no_of_attribute + "`#{element}`"
	 			end

	 		end
	 	else
	 		for i in 0..counter-1
	 			if i < counter-1
	 				no_of_attribute= no_of_attribute + "`attribute_#{i+1}`, "	
	 			else
	 				no_of_attribute= no_of_attribute + "`attribute_#{i+1}`"
	 			end
				
	 		end
	 	end
	 	return no_of_attribute
	end
		
end
