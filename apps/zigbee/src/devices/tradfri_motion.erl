%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(tradfri_motion).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"TRADFRI motion sensor").
-define(Type,"sensors").
%% --------------------------------------------------------------------
%"sensors","7",
%          #{<<"config">> =>
%                #{<<"alert">> => <<"none">>,<<"battery">> => 60,
 %                 <<"delay">> => 180,<<"duration">> => 60,
  %                <<"group">> => <<"7">>,<<"on">> => true,
   %               <<"reachable">> => true},
%            <<"ep">> => 1,
%            <<"etag">> => <<"4f13859576edf6f1d4121ae1e7807387">>,
%            <<"lastannounced">> => <<"2023-11-02T18:13:57Z">>,
%            <<"lastseen">> => <<"2023-11-02T19:39Z">>,
%            <<"manufacturername">> => <<"IKEA of Sweden">>,
%            <<"modelid">> => <<"TRADFRI motion sensor">>,
%            <<"name">> => <<"tradfri_motion_1">>,
%            <<"state">> =>
%                #{<<"dark">> => true,
%                  <<"lastupdated">> => <<"2023-11-02T19:39:41.175">>,
%                  <<"presence">> => false},
%            <<"swversion">> => <<"2.0.022">>,<<"type">> => <<"ZHAPresence">>,
%            <<"uniqueid">> => <<"84:ba:20:ff:fe:9b:d6:4d-01-0006">>}},

%% External exports
-export([
	 is_reachable/2,
	 is_presence/2,
	 is_dark/2
	]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:start{/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_reachable([],[{_Type,_NumId,Map}|_])->
    ConfigMap=maps:get(<<"config">>,Map),
    maps:get(<<"reachable">>,ConfigMap).
	   
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_presence([],[{_Type,_NumId,Map}|_])->
    ConfigMap=maps:get(<<"config">>,Map),
%    io:format("ConfigMap  ~p~n",[{ConfigMap,?MODULE,?LINE}]),
    case maps:get(<<"reachable">>,ConfigMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    StateMap=maps:get(<<"state">>,Map),
%	    io:format("StateMap  ~p~n",[{StateMap,?MODULE,?LINE}]),
	    maps:get(<<"presence">>,StateMap)
    end.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_dark([],[{_Type,_NumId,Map}|_])->
    ConfigMap=maps:get(<<"config">>,Map),
%    io:format("ConfigMap  ~p~n",[{ConfigMap,?MODULE,?LINE}]),
    case maps:get(<<"reachable">>,ConfigMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    StateMap=maps:get(<<"state">>,Map),
%	    io:format("StateMap  ~p~n",[{StateMap,?MODULE,?LINE}]),
	    maps:get(<<"dark">>,StateMap)
    end.

%% ====================================================================
%% Internal functions
%% ====================================================================

		    
    
