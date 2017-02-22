defmodule ElixirDriverTest do
  use ExUnit.Case

  doctest ElixirDriver

  test "map_for_error returns status error and an array of reasons" do
    reason = "I want it to fail"
    result = ElixirDriver.map_for_error reason
    assert_has_key_with_value result, "status", "error"

    assert Map.has_key? result, "errors"
    assert Enum.member? result["errors"], reason
  end

  test "map_for_ast returns status ok and the ast passed" do
    ast = {:my_ast, ["context"], {:nested_ast}}
    result = ElixirDriver.map_for_ast ast
    assert_has_key_with_value result, "status", "ok"
    assert_has_key_with_value result, "ast", ast
  end

  test "driver_info_map contains current version of project" do
    result = ElixirDriver.driver_info_map
    assert Map.has_key? result, "driver"

    driver = result["driver"]
    assert String.contains? driver, "elixir"
    assert String.contains? driver, "0.1.0"
  end

  test "default_map_from_req returns language and version from req" do
    lang = "lang"
    version = "version"
    req = %{"language" => lang, "language_version" => version }
    result = ElixirDriver.default_map_from_req req
    assert_has_key_with_value result, "language", lang
    assert_has_key_with_value result, "language_version", version
  end

  test "default_map_from_req defaults language to 'elixir'" do
    version = "version"
    req = %{ "language_version" => version }
    result = ElixirDriver.default_map_from_req req
    assert_has_key_with_value result, "language", "elixir"
    assert_has_key_with_value result, "language_version", version
  end

  test "default_map_from_req defaults language_version to current elixir version" do
    lang = "lang"
    req = %{ "language" => lang }
    result = ElixirDriver.default_map_from_req req
    assert_has_key_with_value result, "language", lang
    assert_has_key_with_value result, "language_version", System.version()
  end

  test "write_out packs the message and writes it" do
    msg = %{"key" => ["value"]}
    contents = ElixirDriver.pack(msg)

    {:ok, unpacked} = Msgpax.unpack contents
    assert unpacked == msg
  end

  test "build_response returns a valid response for a valid content" do
    %{"status" => "ok", "ast" => ast} = ElixirDriver.build_response "defmodule MyModule do end"
    { definition, _, _ } = ast
    assert definition == :defmodule
  end

  test "build_response returns a valid response for an invalid content" do
    %{"status" => "error", "errors" => errors} = ElixirDriver.build_response "defmodule MyModule  end"
    assert length(errors) > 0
  end

  def assert_has_key_with_value map, key, value do
    assert Map.has_key? map, key
    assert map[key] == value
  end
end
