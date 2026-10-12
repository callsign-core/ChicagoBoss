-module(otp28_load_timestamp_test).
-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/file.hrl").

beam_timestamp_test() ->
    Dir = filename:join(os:getenv("TMPDIR"), "boss-load-timestamp"),
    Source = filename:join(Dir, "otp28_timestamp_fixture.erl"),
    Beam = filename:join(Dir, "otp28_timestamp_fixture.beam"),
    ok = filelib:ensure_dir(Source),
    ok = file:write_file(Source, <<"-module(otp28_timestamp_fixture).\n-export([value/0]).\nvalue()->ok.\n">>),
    {ok, otp28_timestamp_fixture} = compile:file(Source, [{outdir, Dir}]),
    {module, otp28_timestamp_fixture} = code:load_abs(filename:rootname(Beam)),
    try
        ?assertEqual(undefined, proplists:get_value(time, otp28_timestamp_fixture:module_info(compile))),
        Old = {{2020, 1, 1}, {0, 0, 0}},
        Built = {{2021, 1, 1}, {0, 0, 0}},
        New = {{2022, 1, 1}, {0, 0, 0}},
        ok = file:write_file_info(Beam, #file_info{mtime = Built}),
        ok = file:write_file_info(Source, #file_info{mtime = Old}),
        ?assertEqual(Built, boss_load:module_compiled_date(otp28_timestamp_fixture)),
        ?assertNot(boss_load:module_older_than(otp28_timestamp_fixture, [Source])),
        ok = file:write_file_info(Source, #file_info{mtime = New}),
        ?assert(boss_load:module_older_than(otp28_timestamp_fixture, [Source])),
        code:purge(otp28_timestamp_fixture), code:delete(otp28_timestamp_fixture),
        true = code:add_patha(Dir),
        ?assert(boss_load:module_older_than(otp28_timestamp_fixture, [Source])),
        {ok, otp28_timestamp_fixture, Binary} = compile:file(Source, [binary]),
        code:purge(otp28_timestamp_fixture), code:delete(otp28_timestamp_fixture),
        {module, otp28_timestamp_fixture} = code:load_binary(otp28_timestamp_fixture, Source, Binary),
        ?assertEqual(0, boss_load:module_compiled_date(otp28_timestamp_fixture)),
        ?assert(boss_load:module_older_than(otp28_timestamp_fixture, [Source])),
        code:purge(otp28_timestamp_fixture), code:delete(otp28_timestamp_fixture),
        ok = file:delete(Beam),
        ?assert(boss_load:module_older_than(otp28_timestamp_fixture, [Source]))
    after
        code:purge(otp28_timestamp_fixture), code:delete(otp28_timestamp_fixture),
        code:del_path(Dir)
    end.
