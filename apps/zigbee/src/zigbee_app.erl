%%%-------------------------------------------------------------------
%% @doc zigbee public API
%% @end
%%%-------------------------------------------------------------------

-module(zigbee_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    zigbee_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
