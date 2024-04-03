require_relative "test_helper"

class TestApp < Amy::Application
end

class AmyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/"

    body = last_response.body

    assert last_response.ok?
    assert body["Hello"]
  end

  def test_status_ok
    get "/"
    assert_equal last_response.status, 200
  end
end