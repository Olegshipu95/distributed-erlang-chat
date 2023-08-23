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
generator(WorkingThreads, [#threadInitParams = Params | Rest]) ->
  Pid = spawn_link(Params#threadInitParams.module, Params#threadInitParams.function, Params#threadInitParams.args),
  [{Pid, Params} | generator(WorkingThreads, Rest)].

terminate([]) -> ok;
terminate([{_, #threadInitParams = Params} | Rest]) ->
  Params#threadInitParams.module:terminate(),
  terminate(Rest).

restart_child(Pid, WorkingThreads) ->
  {value, {Pid, {Module, Func, Args}}} = lists:keysearch(Pid, 1, WorkingThreads),
  {ok, NewPid} = apply(Module, Func, Args),
  [{NewPid, {Module, Func, Args}} | lists:keydelete(Pid, 1, WorkingThreads)].

loop(WorkingThreads) ->
  receive
    stop -> terminate(WorkingThreads)
  end.