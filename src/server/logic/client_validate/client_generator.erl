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

-record(threadInitParams,
  {module,
  function,
  args = []}).

%% API
-export([]).
%%todo Error processing
init({Id, Role}, Threads) ->
  WorkingThreads = generator([], Threads),
  loop(WorkingThreads).

generator(_, []) -> _;
generator(WorkingThreads, #threadInitParams(module=Module, function=Func, args=Args) = Params) ->
  Pid = spawn_link(Module, Func, Args),
  [{Pid, Module} | generator(WorkingThreads, Params)];
generator(WorkingThreads, #threadInitParams(module=Module, function=Func, args=Args) = Params) ->
  Pid = spawn_link(Module, Func, Args),
  [{Pid, Module} | generator(WorkingThreads, Params)].

terminate([]) -> ok;
terminate([{Pid, Module} | Rest]) ->
  Module:terminate(),
  terminate(Rest).

restart_child(Pid, WorkingThreads) ->
  {value, {Pid, {Module, Func, Args}}} = lists:keysearch(Pid, 1, WorkingThreads),
  {ok, NewPid} = apply(Module, Func, Args),
  [{NewPid, {Module, Func, Args}} | lists:keydelete(Pid, 1, WorkingThreads)].

loop(WorkingThreads) ->
  receive
    stop -> terminate(WorkingThreads)
  end.