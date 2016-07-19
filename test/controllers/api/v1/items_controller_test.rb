require 'test_helper'

class Api::V1::ItemsControllerTest < ActionDispatch::IntegrationTest
  test 'can get all items in index' do
    get '/api/v1/items.json'
    assert_response :success
    items = JSON.parse(response.body)
    assert_equal items.count, 2
  end

  test 'can get one item by its id' do
    id = items(:one).id

    get "/api/v1/items/#{id}"
    item = JSON.parse(response.body)

    assert_response :success
    assert_equal item["id"], id
  end

  test 'can create a new item' do
    item_params = { name: "Saw", description: "I want to play a game" }

    post "/api/v1/items", params: { item: item_params }
    item = Item.last

    assert_response :success
    assert_equal item_params[:name], item.name
  end

  test 'can update existing item' do
    id = items(:one).id
    previous_name = items(:one).name
    item_params = { name: "Sledge" }

    put "/api/v1/items/#{id}", params: { item: item_params }
    item = Item.find_by(id: id)

    assert_response :success
    refute_equal previous_name, item.name
    assert_equal "Sledge", item.name
  end

  test 'can destroy an item' do
    item = items(:one)

    assert_difference('Item.count', -1) do
      delete "/api/v1/items/#{item.id}"
    end

    assert_response :success
    refute Item.find_by(id: item.id)
  end
end
