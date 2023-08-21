%%%-------------------------------------------------------------------
%%% @author olegs
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. авг. 2023 19:18
%%%-------------------------------------------------------------------
-module(client_generator).
-author("olegs").

%% API
-export([]).
%%todo Error processing
init({Id, Role}, Threads) ->
  WorkingThreads = generator([], Threads),
  loop(WorkingThreads).

generator(_, []) -> _;
generator(WorkingThreads, [{Module, Args} | Rest]) ->
  Pid = spawn_link(Module, Module:start(), Args),
  [{Pid, Module} | generator(WorkingThreads, Rest)];
generator(WorkingThreads, [Module | Rest]) ->
  Pid = spawn_link(Module, Module:start(), []),
  [{Pid, Module} | generator(WorkingThreads, Rest)].

terminate([]) -> ok;
terminate([{Pid, Module} | Rest]) ->
  Module:terminate(),
  terminate(Rest).

loop(WorkingThreads) ->
  receive
    stop -> terminate(WorkingThreads)
  end.