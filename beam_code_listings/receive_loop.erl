-module(receive_loop).

-export([run/0]).

run() ->
    pid = spawn(fun () ->
			receive [] -> ok after 1000 -> error end
		end),
    pid ! [].
