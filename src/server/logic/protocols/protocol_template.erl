%%%-------------------------------------------------------------------
%%% @author olegs
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. авг. 2023 23:58
%%%-------------------------------------------------------------------
-module(protocol_template).
-author("olegs").


%% API
-export([]).

%% Waiting for new connection and returns callbacks for communication with client
-callback listen(ProtocolAdapter :: pid()) ->
  {CallbackReceive :: func(), CallbackSend :: func()}.

%% Read data from client
-callback read(Socket) ->
  {ok, Packet :: term()}.

%% Send data to client
-callback write(Socket, Packet :: term()) ->
  ok.

%% Close connection with client
-callback close(Socket) ->
  Close :: func().