%%%-------------------------------------------------------------------
%%% @author olegs
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. авг. 2023 0:13
%%%-------------------------------------------------------------------
{application, chat_server, [
  {description, "distributed chat"},
  {vsn, "1"},
  {registered, []},
  {applications, [
    kernel,
    stdlib
  ]},
  {mod, {chat_server_app, []}},
  {env,
    [
      {websocket_endpoint, "/"},
      {websocket_port, 1337}
    ]
  },
  {modules, []}
]}.