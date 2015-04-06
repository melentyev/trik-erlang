#include "erl_nif.h"

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>


int hello()
{
    printf("%s\n", "hello");
    return 0;
}

int world(int x) 
{
    printf("World: %d\n", x);
    return 0;
}

static ERL_NIF_TERM hello_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    int ret;
    ret = hello();
    return enif_make_int(env, ret);
}

static ERL_NIF_TERM world_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    int y, ret = 0;
    char buf[256];
    if (!enif_get_string(env, argv[0], buf, 256, ERL_NIF_LATIN1)) {
        return enif_make_badarg(env);
    }
    printf("String: %s", buf);
    //if (!enif_get_int(env, argv[0], &y)) {
    //   return enif_make_badarg(env);
    //}
    //ret = world(y);
    return enif_make_int(env, ret);
}

static ERL_NIF_TERM echo_string_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    char data[512];
    if (!enif_get_string(env, argv[0], data, 512, ERL_NIF_LATIN1)) {
        return enif_make_badarg(env);
    }
    puts(data);
    return enif_make_int(env, 0);
}

static ERL_NIF_TERM fwrite_string_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    char filepath[512], data[128];
    FILE *f;
    int datalen;
    if (!enif_get_string(env, argv[0], filepath, 512, ERL_NIF_LATIN1)) {
        return enif_make_badarg(env);
    }
    if (!enif_get_string(env, argv[1], data, 128, ERL_NIF_LATIN1)) {
        return enif_make_badarg(env);
    }
    datalen = strlen(data);
    f = fopen(filepath, "wb");  
    fwrite(data, 1, datalen, f);
    fclose(f);
    return enif_make_int(env, 0);
}

static ErlNifFunc nif_funcs[] = {
    {"hello", 0, hello_nif},
    {"world", 1, world_nif},
    {"echo_string", 1, echo_string_nif},
    {"fwrite_string", 2, fwrite_string_nif}
};

ERL_NIF_INIT(native, nif_funcs, NULL, NULL, NULL, NULL)