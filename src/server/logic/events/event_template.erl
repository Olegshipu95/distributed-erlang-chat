%%%-------------------------------------------------------------------
%%% @author olegs
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. авг. 2023 14:52
%%%-------------------------------------------------------------------
-module(event_template).
-author("olegs").

%% API
-export([]).

-callback init(InitData :: list()) ->
  {ok, State :: term()}.
-callback terminate(Data :: list()) ->
  {ok, State :: term()} | {error, State :: term()}.
-callback handle_event(Args::term()) ->
  Answer::term().