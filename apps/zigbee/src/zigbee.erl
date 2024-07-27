%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50
%%% @doc
%%% 
%%% @end
%%% Created :  2 Jun 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(zigbee). 

-behaviour(gen_server).   
%%--------------------------------------------------------------------
%% Include 
%%
%%--------------------------------------------------------------------

-include("zigbee.rd").
-include("device.hrl").
-include("log.api").


%% API

%% Application handling API

-export([
	 call/3,
	 all_raw/0,
	 all/0,
	 present/0
	]).


-export([start/0,
	 ping/0]).


-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3, format_status/2]).

-define(SERVER, ?MODULE).

%% Record and Data
-record(state, {}).

%% Table or Data models



%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec call(Name :: string(),Function :: atom(), Args :: term()) -> Result :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

call(Name,Function, Args) ->
    gen_server:call(?SERVER,{call,Name,Function, Args},infinity).

%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec all_raw() -> ListOfMaps :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

all_raw() ->
    gen_server:call(?SERVER,{all_raw},infinity).

%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec all() -> ListOfDeviceName :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

all() ->
    gen_server:call(?SERVER,{all},infinity).
%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec present() -> ListOfDeviceName :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

present() ->
    gen_server:call(?SERVER,{present},infinity).



%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
start()->
    application:start(?MODULE).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%% @end
%%--------------------------------------------------------------------
-spec start_link() -> {ok, Pid :: pid()} |
	  {error, Error :: {already_started, pid()}} |
	  {error, Error :: term()} |
	  ignore.
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
ping()-> 
    gen_server:call(?SERVER, {ping},infinity).    

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%% @end
%%--------------------------------------------------------------------
-spec init(Args :: term()) -> {ok, State :: term()} |
	  {ok, State :: term(), Timeout :: timeout()} |
	  {ok, State :: term(), hibernate} |
	  {stop, Reason :: term()} |
	  ignore.
init([]) ->
 
    {ok, #state{},0}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%% @end
%%--------------------------------------------------------------------
-spec handle_call(Request :: term(), From :: {pid(), term()}, State :: term()) ->
	  {reply, Reply :: term(), NewState :: term()} |
	  {reply, Reply :: term(), NewState :: term(), Timeout :: timeout()} |
	  {reply, Reply :: term(), NewState :: term(), hibernate} |
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: term(), Reply :: term(), NewState :: term()} |
	  {stop, Reason :: term(), NewState :: term()}.



handle_call({call,Name,Function, Args}, _From, State) ->
    Reply=case rpc:call(node(),lib_zigbee,get_num_map_module,[Name],5000) of
	      {badrpc,Reason}->
		  {error,["badrpc ",Reason,?MODULE,?LINE]};
	     {error,Reason}->
		 {error,Reason};
	     {ok,Module,ListTypeNumIdMap}->
	%	  io:format(" NumId,Map,Module ~p~n",[{Module,ListTypeNumIdMap,?MODULE,?LINE}]),
		 rpc:call(node(),Module,Function,[Args,ListTypeNumIdMap],5000)
	 end,
    {reply, Reply, State};

handle_call({all_raw}, _From, State) ->
    Reply =lib_zigbee:all_raw(),
    {reply, Reply, State};

handle_call({all}, _From, State) ->
   % Reply = case rd:call(lgh_prhoscon,get_maps,[],5000) of
    Reply =lib_zigbee:all(),
    {reply, Reply, State};


handle_call({present}, _From, State) ->
    Reply = lib_zigbee:present(),
    
    {reply, Reply, State};


handle_call({ping}, _From, State) ->
    Reply = pong,
    {reply, Reply, State};

handle_call(Request, _From, State) ->
    ?LOG_WARNING("Unmatched signal",[Request]),
    Reply = {error,["Unmatched signal ",Request,?MODULE,?LINE]},
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%% @end
%%--------------------------------------------------------------------
-spec handle_cast(Request :: term(), State :: term()) ->
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: term(), NewState :: term()}.

handle_cast({stop}, State) ->
    {stop,normal,ok,State};

handle_cast(Request, State) ->
    ?LOG_WARNING("Unmatched signal",[Request]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%% @end
%%--------------------------------------------------------------------
-spec handle_info(Info :: timeout() | term(), State :: term()) ->
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: normal | term(), NewState :: term()}.

handle_info(timeout, State) ->  
    
        % to be removed used during test
    {ok,HostName}=net:gethostname(),
    ControllerNode=list_to_atom("ctrl"++"@"++HostName),
    Pong=rpc:call(ControllerNode,controller,ping,[],5000),
    ?LOG_NOTICE("Pong ",Pong),
    
     %% Set up logdir 
    file:make_dir(?MainLogDir),
    [NodeName,_HostName]=string:tokens(atom_to_list(node()),"@"),
    NodeNodeLogDir=filename:join(?MainLogDir,NodeName),
    ok=log:create_logger(NodeNodeLogDir,?LocalLogDir,?LogFile,?MaxNumFiles,?MaxNumBytes),

    [rd:add_local_resource(ResourceType,Resource)||{ResourceType,Resource}<-?LocalResourceTuples],
    [rd:add_target_resource_type(TargetType)||TargetType<-?TargetTypes],
    rd:trade_resources(),
    timer:sleep(1000),
    ?LOG_NOTICE("Server started ",[?MODULE]),

   {noreply, State};

handle_info(Info, State) ->
    ?LOG_WARNING("Unmatched signal",[Info]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%% @end
%%--------------------------------------------------------------------
-spec terminate(Reason :: normal | shutdown | {shutdown, term()} | term(),
		State :: term()) -> any().
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%% @end
%%--------------------------------------------------------------------
-spec code_change(OldVsn :: term() | {down, term()},
		  State :: term(),
		  Extra :: term()) -> {ok, NewState :: term()} |
	  {error, Reason :: term()}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called for changing the form and appearance
%% of gen_server status when it is returned from sys:get_status/1,2
%% or when it appears in termination error logs.
%% @end
%%--------------------------------------------------------------------
-spec format_status(Opt :: normal | terminate,
		    Status :: list()) -> Status :: term().
format_status(_Opt, Status) ->
    Status.

%%%===================================================================
%%% Internal functions
%%%===================================================================
