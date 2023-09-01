%%%-------------------------------------------------------------------
%%% @author ivan/oleg
%%% @copyright (C) 2023, <Olevan>
%%% @doc
%%%     This module provides connection through tcp protocol
%%% @end
%%% Created : 28. авг. 2023 12:39
%%%-------------------------------------------------------------------
-module(tcp_protocol).

-define(PORT, 8080).
-define(OPTIONS, []).
-define(TIMEOUT, 0).

%% API
-export([init/1]).

init(ProtocolAdapter) ->
  case gen_tcp:listen(?PORT, ?OPTIONS) of
    {ok, ListenSocket} ->
      ?MODULE:listen(ProtocolAdapter, ListenSocket);
    {error, Reason} ->
      {error, self(), {init, Reason}} ! ProtocolAdapter
  end.

listen(ProtocolAdapter, ListenSocket) ->
  case gen_tcp:accept(ListenSocket) of
    {ok, Socket} ->
      {self(), {fun() -> ?MODULE:read(Socket) end,
        fun(Packet) -> ?MODULE:write(Socket, Packet) end,
        fun() -> ?MODULE:close(Socket) end}} ! ProtocolAdapter,
      ?MODULE:listen(ProtocolAdapter, ListenSocket);
    {error, closed} ->
      {error, self(), {tcp_listener, closed}} ! ProtocolAdapter;
    {error, _} ->
      {error, self(), {tcp_listener, _}} ! ProtocolAdapter,
      ?MODULE:listen(ProtocolAdapter, ListenSocket)
  end.

read(Socket) ->
  gen_tcp:recv(Socket, 0, ?TIMEOUT).

write(Socket, Packet) ->
  gen_tcp:send(Socket, Packet).

close(Socket) ->
  gen_tcp:close(Socket).