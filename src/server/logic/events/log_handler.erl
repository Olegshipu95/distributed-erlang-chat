%%%-------------------------------------------------------------------
%%% @author olegs
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. авг. 2023 17:47
%%%-------------------------------------------------------------------
-module(log_handler).
-author("olegs").

%% API
-export([]).

init(File) ->
  {ok, Fd} = file:open(File, write),
  Fd.
terminate(Fd) ->
  file:close(Fd).
handle_event({Action, Id, Event}, Fd) ->
  {Megasec, Sec, Microsec} = now(),
  io:format(Fd, "~w,~w,~w,~w,~w,~p~n", [Megasec, Sec, Microsec, Action, Id, Event]),
  Fd;
handle_event(_, Fd) ->
  Fd.