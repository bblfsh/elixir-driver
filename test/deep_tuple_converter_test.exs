defmodule DeepTupleConverterTest do
  use ExUnit.Case

  doctest ElixirDriver

  test "converts simple tuples" do
    assert ["1", 2, :three] == DeepTupleConverter.convert({"1", 2, :three})
  end

  test "converts nested tuples" do
    assert ["1", 2, %{:three => [:four]}] == DeepTupleConverter.convert({"1", 2, %{three: {:four}}})
  end
end
