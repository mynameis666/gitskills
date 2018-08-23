@good@
identifier m, var, n;
identifier f;
expression e1, e2, e3;
statement s, s2;
position p;
@@

m = kmalloc@p(...);
... when != var = m;
	when != m->n;
	when != f(m, ...);
(
if (m && ...) s else s2 
|
if (!m || ...) s 
|
if ((NULL == m) || ...) s
| 
if ((m == NULL) || ...) s
|
if (m == 0) s
|
if (m != NULL && ...) s else s2
|
if (!(m && ...)) s
|
if ((unsigned long)m & e1) s
|
unlikely(!m)
|
unlikely(m == NULL)
|
unlikely(NULL == m)
|
WARN_ON(!m)
|
BUG_ON(!m)
|
WARN_ON_ONCE(m == NULL)
|
WARN_ON_ONCE(NULL == m)
|
e1 = m ? e2 : e3;
)

@good_nofail@
identifier m;
constant c;
position p;
@@

m = kmalloc@p(..., c | __GFP_NOFAIL);

@bad@
identifier m;
position p != { good.p, good_nofail.p};
@@

m = kmalloc@p(...);

@script:python depends on bad@
p << bad.p;
@@

print("In file: %s, line: %s address used without check" % (p[0].file, p[0].line))

@script:python depends on good@
p << good.p;
@@

print("In file: %s, line: %s no bug" % (p[0].file, p[0].line))

@script:python depends on good_nofail@
p << good_nofail.p;
@@

print("In file: %s, line: %s no bug" % (p[0].file, p[0].line))

@unchecked@
position p != {good.p, good_nofail.p, bad.p};
@@

kmalloc@p(...)

@script:python@
p << unchecked.p;
@@

print("unchecked kmalloc file: %s, line: %s" % (p[0].file, p[0].line))
