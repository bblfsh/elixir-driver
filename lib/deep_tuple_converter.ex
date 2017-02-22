defmodule DeepTupleConverter do

  def convert tuple do
    PhStTransform.transform(tuple, %{Tuple => fn(t) -> Tuple.to_list(t) end})
  end
end
