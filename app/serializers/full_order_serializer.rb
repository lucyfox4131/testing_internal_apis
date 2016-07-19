class FullOrderSerializer < ActiveModel::Serializer
  attributes :id, :order_number, :num_items, :subtotal

  has_many :items, serializer: OrderItemIndexSerializer

  def num_items
    object.items.count
  end

  def subtotal
    object.order_items.reduce(0) {|sum, order_item| sum + order_item.item_price}
  end
end
