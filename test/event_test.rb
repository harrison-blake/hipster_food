require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/food_truck'
require './lib/event'

class EventTest < Minitest::Test
  def setup
    @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    @food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
    @food_truck3 = FoodTruck.new("Palisade Peach Shack")
    @event = Event.new("South Pearl Street Farmers Market")
  end

  def test_instance_of_and_attributes

    assert_instance_of Event, @event
    assert_equal "South Pearl Street Farmers Market", @event.name
    assert_equal [], @event.food_trucks
  end

  def test_add_food_truck
    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)

    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)

    assert_equal [@food_truck1, @food_truck2], @event.food_trucks
  end

  def test_food_truck_names
    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)

    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)

    assert_equal ["Rocky Mountain Pies", "Ba-Nom-a-Nom"], @event.food_truck_names
  end

  def test_food_trucks_that_sell
    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)
    @food_truck3.stock(@item1, 65)

    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    assert_equal [@food_truck1, @food_truck3], @event.food_trucks_that_sell(@item1)
    assert_equal [@food_truck2], @event.food_trucks_that_sell(@item4)
  end

  def test_potential_revenue
    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)
    @food_truck3.stock(@item1, 65)

    food_truck1_total = @food_truck1.potential_revenue

    assert_equal 148.75, food_truck1_total
    assert_equal 345.00, @food_truck2.potential_revenue
    assert_equal 243.75, @food_truck3.potential_revenue
  end

  def test_sorted_items_list
    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)
    @food_truck3.stock(@item1, 65)
    @food_truck3.stock(@item3, 10)

    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    all_names = ["Apple Pie (Slice)", "Banana Nice Cream",
                 "Peach Pie (Slice)", "Peach-Raspberry Nice Cream"]

    assert_equal all_names, @event.sorted_item_list
  end

  def test_total_inventory
    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)
    @food_truck3.stock(@item1, 65)
    @food_truck3.stock(@item3, 10)

    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    item_inventory_hash = {
     @item1 => {
       quantity: 100,
       food_trucks: [@food_truck1, @food_truck3]
     },
     @item2 => {
       quantity: 7,
       food_trucks: [@food_truck1]
     },
     @item3 => {
       quantity: 35,
       food_trucks: [@food_truck2, @food_truck3]
     },
     @item4 => {
       quantity: 50,
       food_trucks: [@food_truck2]
     },
   }

   assert_equal item_inventory_hash, @event.total_inventory
  end

  def test_overstocked_inventory
    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)
    @food_truck3.stock(@item1, 65)
    @food_truck3.stock(@item3, 10)

    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    assert_equal [@item1], @event.overstocked_items
  end
end
