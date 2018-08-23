@good@
statement S;
identifier m, var;
position p;
@@

m = kmalloc@p(...);
... when != var = m
(
if (!m) S
|
if (m == NULL) S
|
if (m) {
...
} else {
...
}
)

@bad@
identifier m;
position p != good.p;
@@

m = kmalloc@p(...);

@script:python@
p << bad.p;
n << bad.m;
@@

print("bad [%s] at [%s] in file [%s]" % (n, p[0].line, p[0].file))
