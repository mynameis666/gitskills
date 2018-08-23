@good@
identifier f, n;
expression e1, e2, e3, e4;
statement s1, s2;
type t;
position p;
@@

(
e1 = kmalloc@p(...);
|
e1 = (t)kmalloc@p(...);
)
... when != e2 = e1;
	when != e1->n;
	when != f(e1, ...);
(
if (e1 && ...) s1 else s2 
|
if (... || !e1 || ...) s1 else s2 
|
if ((NULL == e1) || ...) s1 else s2
| 
if ((e1 == NULL) || ...) s1 else s2
|
if (e1 == 0) s1 else s2
|
if (e1 != NULL && ...) s1 else s2
|
if (!(e1 && ...)) s1 else s2
|
if ((t)e1 & e2) s1 else s2
|
unlikely(!e1)
|
unlikely(e1 == NULL)
|
unlikely(NULL == e1)
|
WARN_ON(!e1)
|
BUG_ON(!e1)
|
WARN_ON_ONCE(e1 == NULL)
|
WARN_ON_ONCE(NULL == e1)
|
e2 = e1 ? e3 : e4;
)

@good_idt@
identifier m, var, n, f;
statement s1, s2;
position p != good.p;
type t;
@@

t* m = kmalloc@p(...);
... when != var = m;
	when != m->n;
	when != f(m, ...)
(
if (!m) s1 else s2
)

@good_oneline@
statement s1, s2;
expression e;
position p;
@@

(
if ((e = kmalloc@p(...)) == NULL) s1 else s2
|
if (!(e = kmalloc@p(...))) s1 else s2
)

@good_nofail@
constant c;
position p;
@@

kmalloc@p(..., c | __GFP_NOFAIL)


@good_return@
position p;
@@

return kmalloc@p(...);

@bad@
expression e;
position p != {good.p, good_nofail.p, good_return.p, good_idt.p, good_oneline.p};
@@

e = kmalloc@p(...);

@script:python depends on bad@
p << bad.p;
@@

print("In file: %s, line: %s address used without check" % (p[0].file, p[0].line))

@script:python depends on good@
p << good.p;
@@

print("In file: %s, line: %s no bug" % (p[0].file, p[0].line))

@script:python depends on good_idt@
p << good_idt.p;
@@

print("In file: %s, line: %s no bug" % (p[0].file, p[0].line))

@script:python depends on good_nofail@
p << good_nofail.p;
@@

print("In file: %s, line: %s no bug" % (p[0].file, p[0].line))

@script:python depends on good_return@
p << good_return.p;
@@

print("In file: %s, line: %s no bug" % (p[0].file, p[0].line))

@script:python depends on good_oneline@
p << good_oneline.p;
@@

print("In file: %s, line: %s no bug" % (p[0].file, p[0].line))

@unchecked@
position p != {good.p, good_idt.p, good_nofail.p, good_return.p, good_oneline.p, bad.p};
@@

kmalloc@p(...)

@script:python@
p << unchecked.p;
@@

print("unchecked kmalloc file: %s, line: %s" % (p[0].file, p[0].line))
