%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lumi_motion).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"lumi.sensor_motion.aq2").
-define(Type,"sensors").
%% --------------------------------------------------------------------
%{"sensors","9",
%  #{<<"config">> =>
%        #{<<"battery">> => 100,<<"on">> => true,
%          <<"reachable">> => true,<<"temperature">> => 3100,
%          <<"tholddark">> => 12000,<<"tholdoffset">> => 7000},
%    <<"ep">> => 1,
%    <<"etag">> => <<"6ec620cea826db2766f084f1b27aa4a3">>,
%    <<"lastannounced">> => <<"2022-12-20T20:22:40Z">>,
%    <<"lastseen">> => <<"2023-11-02T21:01Z">>,
%    <<"manufacturername">> => <<"LUMI">>,
%    <<"modelid">> => <<"lumi.sensor_motion.aq2">>,
%    <<"name">> => <<"lumi_motion_1">>,
%    <<"state">> =>
%        #{<<"dark">> => false,<<"daylight">> => true,
%          <<"lastupdated">> => <<"2023-11-02T21:01:03.552">>,
%          <<"lightlevel">> => 23839,<<"lux">> => 242},
%    <<"swversion">> => <<"20170627">>,
%    <<"type">> => <<"ZHALightLevel">>,
%    <<"uniqueid">> => <<"00:15:8d:00:01:dd:a2:b8-01-0400">>}},


%"sensors","10",
%  #{<<"config">> =>
%        #{<<"battery">> => 100,<<"duration">> => 90,<<"on">> => true,
%          <<"reachable">> => true,<<"temperature">> => 3100},
%    <<"ep">> => 1,
%    <<"etag">> => <<"094a00153570739fb132675046491386">>,
%    <<"lastannounced">> => <<"2022-12-20T20:22:40Z">>,
%    <<"lastseen">> => <<"2023-11-02T21:01Z">>,
%    <<"manufacturername">> => <<"LUMI">>,
%    <<"modelid">> => <<"lumi.sensor_motion.aq2">>,
%    <<"name">> => <<"lumi_motion_1">>,
%    <<"state">> =>
%        #{<<"lastupdated">> => <<"2023-11-02T21:01:03.560">>,
%          <<"presence">> => true},
%    <<"swversion">> => <<"20170627">>,...}},


%% External exports
-export([
	 is_reachable/2,
	 is_presence/2,

	 is_dark/2,
	 is_daylight/2,
	 lightlevel/2,
	 lux/2
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
is_presence([],ListTypeNumIdMap)->
    StateMaps=[maps:get(<<"state">>,Map)||{_,_,Map}<-ListTypeNumIdMap],
    [Raw]=[maps:get(<<"presence">>,StateMap)||StateMap<-StateMaps,
						   true=:=maps:is_key(<<"presence">>,StateMap)],
    Raw.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_dark([],ListTypeNumIdMap)->
    StateMaps=[maps:get(<<"state">>,Map)||{_,_,Map}<-ListTypeNumIdMap],
    [Raw]=[maps:get(<<"dark">>,StateMap)||StateMap<-StateMaps,
					  true=:=maps:is_key(<<"dark">>,StateMap)],
    Raw.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_daylight([],ListTypeNumIdMap)->
    StateMaps=[maps:get(<<"state">>,Map)||{_,_,Map}<-ListTypeNumIdMap],
    [Raw]=[maps:get(<<"daylight">>,StateMap)||StateMap<-StateMaps,
					  true=:=maps:is_key(<<"daylight">>,StateMap)],
    Raw.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
lightlevel([],ListTypeNumIdMap)->
    StateMaps=[maps:get(<<"state">>,Map)||{_,_,Map}<-ListTypeNumIdMap],
    [Raw]=[maps:get(<<"lightlevel">>,StateMap)||StateMap<-StateMaps,
					  true=:=maps:is_key(<<"lightlevel">>,StateMap)],
    Raw.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
lux([],ListTypeNumIdMap)->
    StateMaps=[maps:get(<<"state">>,Map)||{_,_,Map}<-ListTypeNumIdMap],
    [Raw]=[maps:get(<<"lux">>,StateMap)||StateMap<-StateMaps,
					  true=:=maps:is_key(<<"lux">>,StateMap)],
    Raw.


%% ====================================================================
%% Internal functions
%% ====================================================================

		    
    
