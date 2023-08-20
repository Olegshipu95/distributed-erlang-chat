%%%-------------------------------------------------------------------
%%% @author olegs
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. авг. 2023 14:11
%%%-------------------------------------------------------------------
-module(event_manager).
-author("olegs").

%% API
-export([start/2]).

start(Name, HandlerList)->
  register(Name, spawn(?MODULE, init, [HandlerList])).

init(HandlerList)->
  loop(initialize(HandlerList)).

initialize([]) -> [];
initialize([{Handler, InitData}|Rest])->
  [{Handler,Handler:init(InitData)}|initialize(Rest)].

stop(Name) ->
  Name ! {stop, self()},
  receive {reply, Reply} -> Reply end.

terminate([]) -> [];
terminate([{Handler, Data}| Rest]) ->
  [{Handler, Handler:terminate(Data)}| terminate(Rest)].

handle_msg({add_handler, Handler, InitData}, LoopData) ->
  {ok, [{Handler, Handler:init(InitData)}|LoopData]};
handle_msg({delete_handler, Handler}, LoopData)->
  case lists:keysearch(Handler, 1, LoopData) of
    false ->
      {{error, instance}, LoopData};
    {value, {Handler, Data}} ->
      Reply = {data, Handler:terminate(Data)},
      NewLoopData = lists:keydelete(Handler, 1, LoopData),
      {Reply, NewLoopData}
  end;
handle_msg({get_data, Handler}, LoopData) ->
  case lists:keysearch(Handler, 1, LoopData) of
    false ->
      {{error, instance}, LoopData};
    {value, {Handler, Data}} ->
      {{data, Data}, LoopData}
  end;
handle_msg({send_event, Event}, LoopData) ->
  {ok, event(Event, LoopData)}.

event(_Event, []) -> [];
event(Event, [{Handler, Data}|Rest])->
  [{Handler, Handler:handle_event(Event, Data)}|event(Event, Rest)].

reply(To, Msg) ->
  To! {reply, Msg}.

loop(State) ->
  receive
    {request, From, Msg} ->
      {Reply, NewState} = handle_msg(Msg, State),
      reply (From, Reply),
      loop(NewState);
    {stop, From} ->
      reply(From, terminate(State))
  end.