-module(otp28_service_worker_test).
-include_lib("eunit/include/eunit.hrl").
instance_dispatch_test()->
    State={state,otp28_service_handler,old},
    ?assertEqual({noreply,{state,otp28_service_handler,{request,session,"/socket",socket,hello,old}}},
        boss_service_worker:handle_cast({incoming_msg,"/socket",socket,request,session,hello},State)).
missing_callback_default_test()->
    State={state,otp28_service_handler,old},
    ?assertEqual({noreply,State},boss_service_worker:handle_cast({broadcast,hello},State)).
exception_stack_capture_test()->
    %% Keep the historical catch result; removed get_stacktrace/0 must not mask
    %% the callback's original failure with undef on modern OTP.
    ?assertEqual(ok,boss_service_worker:handle_cast(
        {incoming_msg,"/socket",socket,request,session,fail},{state,otp28_service_handler,old})).
