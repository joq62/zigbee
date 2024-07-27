%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50 
%%% @doc
%%%
%%% @end
%%% Created : 25 Oct 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(lib_zigbee).
 
-include("device.hrl").

%% API
-export([
	 get_num_map_module/1,
	 all/0,
	 all_raw/0,
	 present/0
	]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
get_num_map_module(Name)->
    case all_raw() of
	{error,Reason}->
	    {error,["No Maps available ,Name, Reason",Name, Reason, ?MODULE,?LINE]};
	AllMaps->
	    TYpeNumIdMapList= [{Type,NumId,Map}||{Type,NumId,Map}<-AllMaps,
						 Name=:=binary_to_list(maps:get(<<"name">>,Map))],
	    case TYpeNumIdMapList of
		[]->
		    {error,["Name not found",Name,?MODULE,?LINE]};
		ListTypeNumIdMap->
		    [{Type,NumId,Map}|_]=ListTypeNumIdMap,
		    ModelId=binary_to_list(maps:get(<<"modelid">>,Map)),
						% [Module]=[maps:get(module,DeviceMap)||DeviceMap<-?DeviceInfo,
		    ModuleInList=[maps:get(module,DeviceMap)||DeviceMap<-?DeviceInfo,
							      ModelId=:=maps:get(modelid,DeviceMap)],
						%   ModuleInList=test_get_module(?DeviceInfo,ModelId,false,na),
		    case ModuleInList of
			[]->
			    {error,["Module not identfied Name,ModelId,Type,NumId,Map ",Name,ModelId,Type,NumId,Map]};
			[Module]->
			    {ok,Module,ListTypeNumIdMap}
		    end
	    end
    end.

test_get_module([],ModelId,false,_Module)->
    {error,["Not found ",ModelId]};
test_get_module(_,_ModelId,true,Module)->
    Module;
test_get_module([DeviceMap|T],ModelId,false,_)->
    io:format("ModelId,  DeviceMap ~p~n",[{ModelId,DeviceMap,?MODULE,?LINE}]),
    case ModelId=:=maps:get(modelid,DeviceMap) of
	true->
	    Found=true,
	    Module=[maps:get(module,DeviceMap)];
	false ->
	    Found=false,
	    Module=na
    end,
    io:format("Found, Module ~p~n",[{Found, Module,?MODULE,?LINE}]),
    test_get_module(T,ModelId,Found,Module).
%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
present()->
    


    ok.


%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
all_raw()->
    Result=case rd:call(phoscon,get_maps,[],5000) of
	       {error,Reason}->
		   {error,[Reason,?MODULE,?LINE]};
	       TypeMaps->
		   get_info_raw(TypeMaps,[])
	   end,
    Result.

%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
all()->
    Result=case rd:call(phoscon,get_maps,[],5000) of
	       {error,Reason}->
		   {error,[Reason,?MODULE,?LINE]};
	       TypeMaps->
		   get_info(TypeMaps,[])
	   end,
    Result.



%%%===================================================================
%%% Internal functions
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
get_info_raw([],Acc)->
    lists:append(Acc);
get_info_raw([{Type,Map}|T],Acc)->
    L=maps:to_list(Map),
    AllMaps=format_info_raw(L,Type,[]),
    get_info_raw(T,[AllMaps|Acc]).

format_info_raw([],_Type,Acc)->
    Acc;
format_info_raw([{NumIdBin,Map}|T],Type,Acc)->
    NumId=binary_to_list(NumIdBin),
    format_info_raw(T,Type,[{Type,NumId,Map}|Acc]).
%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
get_info([],Acc)->
    lists:append(Acc);
get_info([{Type,Map}|T],Acc)->
    L=maps:to_list(Map),
    AllInfo=format_info(L,Type,[]),
    get_info(T,[AllInfo|Acc]).
    
format_info([],_Type,Acc)->
    Acc;
format_info([{NumIdBin,Map}|T],Type,Acc)->
    NumId=binary_to_list(NumIdBin),
    Name=binary_to_list(maps:get(<<"name">> ,Map)),
    ModelId=binary_to_list(maps:get(<<"modelid">>,Map)),
    format_info(T,Type,[{Type,NumId,Name,ModelId}|Acc]).


	   
