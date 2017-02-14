defmodule DexyPluginGatewayTest do

  use ExUnit.Case
  doctest DexyPluginGateway

  test "the truth" do
    req = %{app: "idvphone", fun: "auth"}
    args = ["arg1", "arg2"]
    opts = %{}
    state = %{mappy: %{}, req: req, args: args, opts: opts}
    {_, res} = DexyPluginGateway.on_call state
    IO.inspect res
  end

end
