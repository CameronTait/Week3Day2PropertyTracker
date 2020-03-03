require('pry-byebug')
require_relative('models/property.rb')

PropertyTracker.delete_all

property1 = PropertyTracker.new({'address' => '12 Main Street', 'value' => '1000000', 'year_built' => 1992, 'square_footage' => 1000 })

property2 = PropertyTracker.new({'address' => '6 North Avenue', 'value' => '50000', 'year_built' => 2001, 'square_footage' => 500 })

property3 = PropertyTracker.new({'address' => '400 Wall Street', 'value' => '750000', 'year_built' => 11955, 'square_footage' => 2000 })




property1.save
property2.save
property3.save

findProp= PropertyTracker.find(2)
# print(findProp)
# binding.pry()

property3.value = 10
property3.update

#binding.pry
nil
