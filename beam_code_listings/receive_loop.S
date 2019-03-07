{module, receive_loop}.  %% version = 0

{exports, [{module_info,0},{module_info,1},{run,0}]}.

{attributes, []}.

{labels, 13}.


{function, run, 0, 2}.
  {label,1}.
    {line,[{location,"receive_loop.erl",5}]}.
    {func_info,{atom,receive_loop},{atom,run},0}.
  {label,2}.
    {allocate,0,0}.
    {make_fun2,{f,9},0,0,0}.
    {line,[{location,"receive_loop.erl",6}]}.
    {call_ext,1,{extfunc,erlang,spawn,1}}.
    {test,is_eq_exact,{f,3},[{x,0},{atom,pid}]}.
    {move,nil,{x,1}}.
    {move,{atom,pid},{x,0}}.
    {line,[{location,"receive_loop.erl",9}]}.
    send.
    {deallocate,0}.
    return.
  {label,3}.
    {line,[{location,"receive_loop.erl",6}]}.
    {badmatch,{x,0}}.


{function, module_info, 0, 5}.
  {label,4}.
    {line,[]}.
    {func_info,{atom,receive_loop},{atom,module_info},0}.
  {label,5}.
    {move,{atom,receive_loop},{x,0}}.
    {line,[]}.
    {call_ext_only,1,{extfunc,erlang,get_module_info,1}}.


{function, module_info, 1, 7}.
  {label,6}.
    {line,[]}.
    {func_info,{atom,receive_loop},{atom,module_info},1}.
  {label,7}.
    {move,{x,0},{x,1}}.
    {move,{atom,receive_loop},{x,0}}.
    {line,[]}.
    {call_ext_only,2,{extfunc,erlang,get_module_info,2}}.


{function, '-run/0-fun-0-', 0, 9}.
  {label,8}.
    {line,[{location,"receive_loop.erl",6}]}.
    {func_info,{atom,receive_loop},{atom,'-run/0-fun-0-'},0}.
  {label,9}.
    {line,[{location,"receive_loop.erl",7}]}.
  {label,10}.
    {loop_rec,{f,12},{x,0}}.
    {test,is_nil,{f,11},[{x,0}]}.
    remove_message.
    {move,{atom,ok},{x,0}}.
    return.
  {label,11}.
    {loop_rec_end,{f,10}}.
  {label,12}.
    {wait_timeout,{f,10},{integer,1000}}.
    timeout.
    {move,{atom,error},{x,0}}.
    return.
