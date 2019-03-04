{module, add}.  %% version = 0

{exports, [{add,2},{module_info,0},{module_info,1}]}.

{attributes, []}.

{labels, 9}.


{function, add, 2, 2}.
  {label,1}.
    {func_info,{atom,add},{atom,add},2}.
  {label,2}.
                                                %                   |  x0      x1     y0
    {allocate,1,2}.                             %                   | A      B      -
    {move,{x,1},{y,0}}.                         % y0 := x1 (B)      | %      %      B
    {call,1,{f,4}}.                             %                   | id(A)  -      %
    {move,{x,0},{x,1}}.                         % x1 := x0 (id(A))  | %      id(A)  %
    {move,{y,0},{x,0}}.                         % x0 := y0 (B)      | B      %      %
    {move,{x,1},{y,0}}.                         % y0 := x1 (id(A))  | %      %      id(A)
    {call,1,{f,4}}.                             %                   | id(B)  -      %
    {gc_bif,'+',{f,0},1,[{y,0},{x,0}],{x,0}}.
    {deallocate,1}.
    return.


{function, id, 1, 4}.
  {label,3}.
    {func_info,{atom,add},{atom,id},1}.
  {label,4}.
    return.


{function, module_info, 0, 6}.
  {label,5}.
    {func_info,{atom,add},{atom,module_info},0}.
  {label,6}.
    {move,{atom,add},{x,0}}.
    {call_ext_only,1,{extfunc,erlang,get_module_info,1}}.


{function, module_info, 1, 8}.
  {label,7}.
    {func_info,{atom,add},{atom,module_info},1}.
  {label,8}.
    {move,{x,0},{x,1}}.
    {move,{atom,add},{x,0}}.
    {call_ext_only,2,{extfunc,erlang,get_module_info,2}}.
