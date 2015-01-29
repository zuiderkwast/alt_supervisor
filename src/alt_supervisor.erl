%% @doc Tries to start and supervise one of multiple of alternative workers.
-module(alt_supervisor).

-behaviour(supervisor).

-export([init/1]).

init(AltChildSpecs) ->
    MgrArgs = [AltChildSpecs],
    MgrSpec = {alt_supervisor_mgr, {alt_supervisor_mgr, start_link, MgrArgs},
               permanent, 5000, worker, [alt_supervisor_mgr]},
    SupSpec = {alt_supervisor_sup, {alt_supervisor_sup, start_link, [self()]},
               permanent, infinity, supervisor, [alt_supervisor_sup]},
    {ok, {{rest_for_one, 10, 10}, [MgrSpec, SupSpec]}}.
