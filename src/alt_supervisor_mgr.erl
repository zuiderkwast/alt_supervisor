-module(alt_supervisor_mgr).
-behaviour(gen_server).

%% API.
-export([start_link/1]).

%% gen_server.
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

%% API.

-spec start_link([supervisor:child_spec()]) -> {ok, pid()}.
start_link(ChildSpecs) ->
    gen_server:start_link(?MODULE, ChildSpecs, []).

%% gen_server.

init(ChildSpecs) ->
    {ok, ChildSpecs}.

handle_call(pop_child_spec, _From, [C|Cs]) ->
    {reply, C, Cs};
handle_call(pop_child_spec, _From, []) ->
    {stop, normal, no_child_spec, []};
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
