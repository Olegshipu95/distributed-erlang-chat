%%%-------------------------------------------------------------------
%%% @author olegs
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. авг. 2023 12:39
%%%-------------------------------------------------------------------
-module(tcp_protocol).
-author("olegs").

-behavior(protocol_template).
-define(PORT, 8080).
-define(OPTIONS, []).
-define(TIMEOUT, 0).

%% API
-export([listen/1, read/1, write/2, close/1]).

listen(ProtocolAdapter) ->
  {ok, ListenSocket} = gen_tcp:listen(?PORT, ?OPTIONS),
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  {fun() -> read(Socket) end, fun(Packet) -> write(Socket, Packet) end, fun() -> close(Socket) end} ! ProtocolAdapter.

read(Socket) ->
  case gen_tcp:recv(Socket, 0, ?TIMEOUT) of
    {ok, Packet} ->
      Packet;
    {error, Reason} ->
      Reason
  end.

write(Socket, Packet) ->
  gen_tcp:send(Socket, Packet).

close(Socket) ->
  gen_tcp:close(Socket).