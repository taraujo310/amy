# frozen_string_literal: true

require "rack/request"
require_relative "test_helper"

class TestController < Amy::Controller
  def action
    "Hello!"
  end

  def exception
    raise "500 Error"
  end
end

class MyControllerTest < Test::Unit::TestCase
  def setup
    env = {
      "PATH_INFO" => "/test/action",
      "QUERY_STRING" => "id=1",
      "REQUEST_METHOD" => "GET",
      "REQUEST_URI" => "http://127.0.0.1:3001/test/action?id=1"
    }
    @controller = TestController.new(env)
  end

  def test_controller_knows_its_name
    assert_equal @controller.controller_name, "test"
  end

  def test_it_holds_rack_request
    assert @controller.request.instance_of?(Rack::Request)
  end

  def test_it_exposes_params
    params = @controller.params

    assert params.key?("id")
    assert_equal params["id"], "1"
  end

  def test_make_response_for_returns_success_with_body
    response = @controller.make_response_for "action"
    assert_equal response[:body], ["Hello!"]
    assert_equal response[:status], 200
  end

  def test_make_response_for_returns_internal_error_with_body
    response = @controller.make_response_for "exception"
    assert_equal response[:body], ["500 - Internal Server Error"]
    assert_equal response[:status], 500
  end

  def test_make_response_for_returns_not_found
    response = @controller.make_response_for "missing"
    assert_equal response[:body], ["404 - Not Found"]
    assert_equal response[:status], 404
  end
end
