defmodule DexyPluginGateway do

  @moduledoc """
  Documentation for DexyPluginGateway.
  """

  require Logger
  otp_app = :dexy_plugin_gateway
  default_request_timeout = 5_000
  @request_timeout Application.get_env(otp_app, __MODULE__)[:request_timeout] || (
    Logger.warn ":request_timeout not configured, default: #{default_request_timeout}ms";
    default_request_timeout
  )

  @doc """
  Hello world.

  ## Examples

      iex> DexyPluginGateway.hello
      :world

  """
  def hello do
    :world
  end

  def on_call state = %{req: req} do
    case node_mbox req.app do
      {_node, _mbox} = node_mbox ->
        request_id = request_id()
        timeout = request_timeout(state)
        msg = request_msg request_id, state
        send_request(node_mbox, msg)
        res = await_response(request_id, timeout)
        IO.inspect node_mbox: node_mbox, msg: msg, res: res
        {state, res}
      _ ->
        {state, nil}
    end
  end

  defp send_request node_mbox, msg do
    send node_mbox, msg
  end

  defp await_response request_id, timeout do
    receive do
      {^request_id, result} -> result
      _ -> "invalid"
    after timeout ->
      "timeout"
    end
  end

  defp request_id do -(:erlang.unique_integer) end
  defp node_mbox(app) do config(app) end

  defp request_msg request_id, state = %{req: req, args: args, opts: opts} do
    opts = Map.put(opts, "data", pipe_data state)
    {self(), request_id, req.app, req.fun, args, opts}
  end

  defp request_timeout _state = %{opts: opts} do
    opts["gw_timeout"] || @request_timeout
  end

  defp config key do
    Application.get_env(:dexy_plugin_gateway, __MODULE__)[key]
  end

  defp pipe_data _state = %{mappy: map} do
    Map.get map, "data"
  end

end
