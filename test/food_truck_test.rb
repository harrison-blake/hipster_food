require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/food_truck'

class FoodTruckTest < Minitest::Test
  def setup
    @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    @food_truck = FoodTruck.new("Rocky Mountain Pies")
  end

  def test_instance_of_and_attributes
    empty_hash = {}

    assert_instance_of FoodTruck, @food_truck
    assert_equal "Rocky Mountain Pies", @food_truck.name
    assert_equal empty_hash, @food_truck.inventory
  end

  def test_check_stock

    assert_equal 0, @food_truck.check_stock(@item1)
  end

  def test_stock
    @food_truck.stock(@item1, 30)
    @food_truck.stock(@item1, 25)
    @food_truck.stock(@item2, 12)

    food_truck_inventory = {@item1 => 55, @item2 => 12}

    assert_equal 55, @food_truck.check_stock(@item1)
    assert_equal 12, @food_truck.check_stock(@item2)
    assert_equal food_truck_inventory, @food_truck.inventory
  end

  def test_potential_revenue
    @food_truck.stock(@item1, 1)
    @food_truck.stock(@item1, 1)
    @food_truck.stock(@item2, 1)

    total = (3.75 + 3.75 + 2.50)

    assert_equal total, @food_truck.potential_revenue
  end
end
