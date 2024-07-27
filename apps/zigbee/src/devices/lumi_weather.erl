%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lumi_weather).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"lumi.weather").
-define(Type,"sensors").
%% --------------------------------------------------------------------
 %{"sensors","6",
 %          #{<<"config">> =>
 %                #{<<"battery">> => 98,<<"offset">> => 0,<<"on">> => true,
 %                  <<"reachable">> => true},
 %            <<"ep">> => 1,
 %            <<"etag">> => <<"a593c30c0ad620e476830b17586cff50">>,
 %            <<"lastannounced">> => null,
 %            <<"lastseen">> => <<"2023-10-30T21:11Z">>,
 %            <<"manufacturername">> => <<"LUMI">>,
 %            <<"modelid">> => <<"lumi.weather">>,
 %            <<"name">> => <<"weather_1">>,
 %            <<"state">> =>
 %                #{<<"lastupdated">> => <<"2023-10-30T21:05:25.419">>,
 %                  <<"pressure">> => 1011},
 %            <<"swversion">> => <<"3000-0001">>,
 %            <<"type">> => <<"ZHAPressure">>,
 %            <<"uniqueid">> => <<"00:15:8d:00:06:e3:cf:fe-01-0403">>}},
 %{"sensors","5",
 %          #{<<"config">> =>
 %                #{<<"battery">> => 98,<<"offset">> => 0,<<"on">> => true,
 %                  <<"reachable">> => true},
 %            <<"ep">> => 1,
 %            <<"etag">> => <<"8c4112cbba9448324a7a18ef43b7f256">>,
 %            <<"lastannounced">> => null,
 %            <<"lastseen">> => <<"2023-10-30T21:11Z">>,
 %            <<"manufacturername">> => <<"LUMI">>,
 %            <<"modelid">> => <<"lumi.weather">>,
 %            <<"name">> => <<"weather_1">>,
 %            <<"state">> =>
 %                #{<<"lastupdated">> => <<"2023-10-30T21:05:25.362">>,
 %                  <<"temperature">> => 2341},
 %            <<"swversion">> => <<"3000-0001">>,
 %            <<"type">> => <<"ZHATemperature">>,
 %            <<"uniqueid">> => <<"00:15:8d:00:06:e3:cf:fe-01-0402">>}},
 %         {"sensors","4",
 %          #{<<"config">> =>
 %                #{<<"battery">> => 98,<<"offset">> => 0,<<"on">> => true,
 %                  <<"reachable">> => true},
 %            <<"ep">> => 1,
 %            <<"etag">> => <<"8c4112cbba9448324a7a18ef43b7f256">>,
 %            <<"lastannounced">> => null,
 %            <<"lastseen">> => <<"2023-10-30T21:11Z">>,
 %            <<"manufacturername">> => <<"LUMI">>,
 %            <<"modelid">> => <<"lumi.weather">>,
 %            <<"name">> => <<"weather_1">>,
 %            <<"state">> =>
 %                #{<<"humidity">> => 3454,
 %                  <<"lastupdated">> => <<"2023-10-30T21:05:25.395">>},
 %            <<"swversion">> => <<"3000-0001">>,
 %            <<"type">> => <<"ZHAHumidity">>,
 %            <<"uniqueid">> => <<"00:15:8d:00:06:e3:cf:fe-01-0405">>}},


%% External exports
-export([
	 is_reachable/2,
	 temp/2,
	 humidity/2,
	 pressure/2
	]). 


%% ====================================================================
%% External functions
%% ====================================================================
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
is_reachable([],[{_Type,_NumId,Map}|_])->
    ConfigMap=maps:get(<<"config">>,Map),
    maps:get(<<"reachable">>,ConfigMap).
	   
	  
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
temp([],ListTypeNumIdMap)->
    StateMaps=[maps:get(<<"state">>,Map)||{_,_,Map}<-ListTypeNumIdMap],
    [Raw]=[maps:get(<<"temperature">>,StateMap)||StateMap<-StateMaps,
						 true=:=maps:is_key(<<"temperature">>,StateMap)],
    Raw/100.
							     
							     
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
humidity([],ListTypeNumIdMap)->
    StateMaps=[maps:get(<<"state">>,Map)||{_,_,Map}<-ListTypeNumIdMap],
    [Raw]=[maps:get(<<"humidity">>,StateMap)||StateMap<-StateMaps,
					      true=:=maps:is_key(<<"humidity">>,StateMap)],
    Raw/100.
							     
							     
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
pressure([],ListTypeNumIdMap)->
    StateMaps=[maps:get(<<"state">>,Map)||{_,_,Map}<-ListTypeNumIdMap],
    [Raw]=[maps:get(<<"pressure">>,StateMap)||StateMap<-StateMaps,
					      true=:=maps:is_key(<<"pressure">>,StateMap)],
    Raw.

