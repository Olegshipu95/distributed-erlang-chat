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

%% API
-export([listen/1, read/1, write/2, close/0]).

listen(ProtocolAdapter) ->
  {ok, ListenSocket} = gen_tcp:listen(?PORT, ?OPTIONS),
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  {fun() -> read(Socket) end, fun(Data) -> write(Socket, Data) end}.

read(Socket) ->
  erlang:error(not_implemented).

write(Socket, Data) ->
  erlang:error(not_implemented).

close() ->
  erlang:error(not_implemented).