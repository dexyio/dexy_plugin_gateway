defmodule DexyPluginGatewayTest do

  use ExUnit.Case
  doctest DexyPluginGateway

  test "the truth" do
    args = ["arg1", "arg2"]
    opts = %{}
    state = %{mappy: %{}, fun: "foo.bar", args: args, opts: opts}
    {_, res} = DexyPluginGateway.on_call state
    IO.inspect res
  end

end
