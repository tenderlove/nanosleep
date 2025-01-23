#include <ruby.h>
#include <ruby/thread.h>
#include <time.h>

static void *
do_sleep(void * _req)
{
    struct timespec * req = (struct timespec *)_req;

    nanosleep(req, NULL);

    return NULL;
}

static VALUE
nsleep(VALUE mod, VALUE sec, VALUE nsec, VALUE hold_gvl)
{
    struct timespec req;

    req.tv_sec = NUM2INT(sec);
    req.tv_nsec = NUM2INT(nsec);

    if (RTEST(hold_gvl)) {
        do_sleep(&req);
    } else {
        rb_thread_call_without_gvl(do_sleep, &req, RUBY_UBF_PROCESS, 0);
    }

    return Qnil;
}

void Init_nanosleep() {
    VALUE mNanosleep = rb_define_module("Nanosleep");

    rb_define_method(mNanosleep, "nsleep", nsleep, 3);
}
