# Selected upstream timestamp fix

- Tracking: https://github.com/qubit-asia/qcb/issues/889.
- Adapt the timestamp intent of upstream `e40e48252e284a1676896bfbba8dc892b7c46e1b`; retain existing loader APIs, output-directory choices and source compilation behavior.
- Preserve historical compile-time metadata when present. When absent, use the loaded `.beam` file's local modification time. Missing, preloaded or source/in-memory modules retain conservative recompilation.
- Keep dependency versions unchanged except the exact companion BossDB source pin. No upstream dependency graph, runtime startup or transport changes are imported.
- Verify deterministic older/newer source files, unloaded and source-loaded modules, missing BEAM files, and the QCB gen8 native/full-runtime integration/failure/recovery lane before merge.
