-module(otp28_service_handler).
-export([handle_incoming/5]).
handle_incoming(_URL,_Socket,fail,_Internal,_Instance)->error(synthetic_callback_failure);
handle_incoming(URL,Socket,Message,Internal,{?MODULE,Request,Session})->
    {noreply,{Request,Session,URL,Socket,Message,Internal}}.
