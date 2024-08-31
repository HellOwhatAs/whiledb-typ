#import "@local/whiledb:0.1.0": whiledb_exec;
#set heading(numbering: "1.")

#let whiledb(src) = {
  let res = whiledb_exec(src);
  src;
  block(
    fill: rgb("#d8dde8"),
    inset: 8pt,
    radius: 5pt,
    text(fill: if res.err { red } else { rgb("#1d2433") }, raw(res.result)),
  )
}

= Error
#whiledb(```
write_int(123 / 0);
```)

#whiledb(```
// parse err, no comment
```)

#whiledb(```
*10
```)

#whiledb(```
*10 = 10
```)
#whiledb(```
1 + 2 = 3
```)

#whiledb(```
func()
```)

#whiledb(```
variable
```)

= Basic
#whiledb(```
n = read_int();
m = n + 1;
write_int(m + 2);
write_char(10)
```)

= Chars
#whiledb(```
n = 1;
i = 2;
flag = 1;
while (flag && i * i <= n) do {
  if (n % i == 0)
  then { flag = 0 }
  else { flag = 1 };
  i = i + 1
};
if (flag)
then {
  write_char(80);
  write_char(82);
  write_char(73);
  write_char(77);
  write_char(69);
  write_char(10)
}
else {
  write_char(78);
  write_char(79);
  write_char(78);
  write_char(80);
  write_char(82);
  write_char(73);
  write_char(77);
  write_char(69);
  write_char(10)
}
```)

= Loops
#whiledb(```
n = read_int();
i = 0;
s = 0;
while (i < n) do {
  s = s + read_int();
  i = i + 1
};
write_int(s);
write_char(10)
```)

= Abs
#whiledb(```
n = -111;
if (n >= 0)
then {
  write_int(n)
}
else {
  write_int(- n)
};
write_char(10)
```)