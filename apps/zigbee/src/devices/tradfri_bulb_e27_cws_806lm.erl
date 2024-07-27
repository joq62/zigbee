%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(tradfri_bulb_e27_cws_806lm).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"TRADFRI bulb E27 CWS 806lm").
-define(Type,"lights").
%% --------------------------------------------------------------------
% {"lights",
%            #{<<"colorcapabilities">> => 0,<<"ctmax">> => 65279,
%              <<"ctmin">> => 0,
%              <<"etag">> => <<"5c75356f0f0a0e0e1f75eaf1d33e333e">>,
%              <<"hascolor">> => true,
%              <<"lastannounced">> => <<"2023-10-30T19:18:38Z">>,
%              <<"lastseen">> => <<"2023-10-30T19:52Z">>,
%              <<"manufacturername">> => <<"IKEA of Sweden">>,
%              <<"modelid">> => <<"TRADFRI bulb E27 CWS 806lm">>,
%              <<"name">> => <<"lamp_1">>,
%              <<"state">> =>
%                  #{<<"alert">> => <<"none">>,<<"bri">> => 108,
%                    <<"colormode">> => <<"ct">>,<<"ct">> => 250,
%                    <<"effect">> => <<"none">>,<<"hue">> => 44378,
%                    <<"on">> => true,<<"reachable">> => true,<<"sat">> => 254,
%                    <<"xy">> => [0.172,0.0438]},
%              <<"swversion">> => <<"1.0.021">>,
%              <<"type">> => <<"Extended color light">>,
%              <<"uniqueid">> => <<"2c:11:65:ff:fe:d4:8a:53-01">>}},



%% External exports
-export([
	 is_reachable/2,
	 is_on/2,
	 is_off/2,
	 turn_on/2,
	 turn_off/2
	]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_reachable([],[{_Type,_NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    maps:get(<<"reachable">>,StateMap).
	   
	   
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_on([],[{_Type,_NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    maps:get(<<"on">>,StateMap)
    end.
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
is_off([],ListTypeNumIdMap)->
    false=:=is_on([],ListTypeNumIdMap).
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
turn_on([],[{_Type,NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    Id=NumId,
	    Key=list_to_binary("on"),
	    Value=true,
	    DeviceType=?Type,
	    rd:call(phoscon_control,set_state,[Id,Key,Value,DeviceType],5000)
    end.

%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
turn_off([],[{_Type,NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    Id=NumId,
	    Key=list_to_binary("on"),
	    Value=false,
	    DeviceType=?Type,
	    rd:call(phoscon_control,set_state,[Id,Key,Value,DeviceType],5000)
    end.



%% ====================================================================
%% Internal functions
%% ====================================================================
%%--------------------------------------------------------------------
	    
    
