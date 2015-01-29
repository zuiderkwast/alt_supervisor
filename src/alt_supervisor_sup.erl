-module(alt_supervisor_sup).

-export([init/1]).

init(SuperSup) ->
    [Mgr] = [Child || {alt_supervisor_mgr, Child, worker, _}
                      <- supervisor:which_children(SuperSup)],
    ChildSpec = gen_server:call(Mgr, pop_child_spec),
    {ok, {{one_for_one, 0, 1}, [ChildSpec]}}.
