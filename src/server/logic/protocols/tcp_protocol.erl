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

%% API
-export([listen/1, read/0, write/1, close/0]).

listen(ProtocolAdapter) ->
  erlang:error(not_implemented).

read() ->
  erlang:error(not_implemented).

write(Packet) ->
  erlang:error(not_implemented).

close() ->
  erlang:error(not_implemented).