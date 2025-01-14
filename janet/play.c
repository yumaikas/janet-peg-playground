#include <emscripten.h>
#include "janet.h"


EMSCRIPTEN_KEEPALIVE
int run_janet_peg(char *pattern, char *string) {
    janet_init();


    JanetTable *env = janet_core_env(NULL);
    Janet jsprintf;
    int ret_1 = janet_dostring(env, "(defn fmt [& args] (string/format ;args))", "play.c", &jsprintf);

    Janet code_template = janet_cstringv("(peg/match %s %q)");
    Janet patt = janet_cstringv(pattern);
    Janet str = janet_cstringv(string);

    Janet args[3] = { code_template, patt, str };
    Janet j_to_exec;
    JanetSignal sig = janet_pcall(janet_unwrap_function(jsprintf), 3, args, &j_to_exec, NULL);

    if (janet_checktype(j_to_exec, JANET_STRING)) {
        Janet result;

        int ret = janet_dostring(env, janet_unwrap_string(j_to_exec), "PEG Playground", &result);
        janet_printf("%j\n", result);
        janet_deinit();
        return ret;
    } else {
        janet_eprintf("Error: %q isn't a string!\n", j_to_exec);
        janet_deinit();
        return 2;
    }

    janet_deinit();
    return 3;
}
