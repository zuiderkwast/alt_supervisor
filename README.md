alt_supervisor
==============

An Erlang OTP supervisor that starts and supervises one child using one of
multiple alternative child specs.

The module `alt_supervisor` is a supervisor that takes a list of child specs
to its `start_link/1`. The alt_supervisor tries to start one child using the
first child spec. If it crashes or fails to start, it tries another child spec.
When all child specs have been tried, the alt_supervisor itself crashes.

Typically the alt_supervisor is itself part of a supervision tree, thus when all
alternatives have been tried and the alt_supervisor crashes, it will be started
again by its parant supervisor. In this way it becomes a "round robin
supervisor".

Example:

```Erlang
-module(my_supervisor).
-behaviour(supervisor).

start_link() ->
    supervisor:start_link(?MODULE, []).

init([]) ->
    AltDbChildSpecs = [
        {db, {mysql, start_link, [{name, {local, db}}, {host, Host},
                                  {user, "aladdin"}, {password, "sesame"}]},
         permanent, 5000, worker, [mysql]}
        || Host <- ["192.168.0.42", "192.168.0.43"]
    ],
    ChildSpecs = [
        {db, {alt_supervisor, start_link, [AltDbChildSpecs]},
         permanent, infinity, supervisor, [alt_supervisor]},
        %%
        %% Other child specs here...
        %%
    ],
    {ok, {{one_for_one, 10, 10}, ChildSpecs}}.
```

Structure
---------

Here is the supervision tree:

```
              alt_supervisor
               (supervisor)
               /           \
  alt_supervisor_mgr   alt_supervisor_sup
    (gen_server)          (supervisor)
                               \
                               child
                         (worker or supervisor)
```
