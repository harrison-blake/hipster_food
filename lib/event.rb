class Event
  attr_reader :name, :food_trucks

  def initialize(name)
    @name = name
    @food_trucks = []
  end

  def add_food_truck(truck)
    @food_trucks << truck
  end

  def food_truck_names
    @food_trucks.map do |truck|
      truck.name
    end
  end

  def food_trucks_that_sell(item)
    @food_trucks.reduce([]) do |acc, truck|
      acc << truck if truck.check_stock(item) > 0
      acc
    end
  end

  def sorted_item_list
    names = []
    @food_trucks.each do |truck|
      truck.inventory.each do |item, amount|
        names << item.name if !names.include?(item.name)
      end
    end

    names.sort
  end

  def total_inventory
    get_items_point_to_hash.each do |item, hash|
      @food_trucks.each do |truck|
        hash[:quantity] += truck.check_stock(item)
        hash[:food_trucks] << truck if truck.check_stock(item) > 0
      end
    end
  end

  def overstocked_items
    items = []
    total_inventory.each do |item, hash|
      if hash[:quantity] > 50 && hash[:food_trucks].length > 1
        items << item
      end
    end

    items
  end

  def get_items_point_to_hash
    get_unique_items.reduce({}) do |acc, item|
        acc[item] = {:quantity => 0, :food_trucks => []}
        acc
    end
  end

  def get_unique_items
    items = []
    @food_trucks.each do |truck|
      truck.inventory.each do |item, amount|
        items << item
      end
    end

    items.uniq
  end
end
