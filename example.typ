#import "@local/whiledb:0.1.0": whiledb_exec;
#set heading(numbering: "1.")
#set page(height: auto, width: auto, fill: white)

#let whiledb(src, stdins: ("",)) = {
  assert(type(stdins) == array, message: "stdins must be array");
  let src = if type(src) == str { src } else { src.text };
  raw(src);
  stack(dir: ltr, spacing: 2em, ..{
    stdins.map(stdin => {
      let stdin = if type(stdin) == str { stdin } else { stdin.text };
      let res = whiledb_exec(src, stdin: stdin);
      set block(inset: 6pt, radius: 5pt, spacing: 1pt)
      if stdin.len() > 0 {
        block(fill: rgb("#e5ceec"), raw("stdin> " + stdin))
      }
      block(fill: rgb("#d8dde8"), text(fill: if res.err { red } else { rgb("#1d2433") }, raw(res.result)))
    })
  })
}

= Errors
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

#whiledb(```
read_int()
```, stdins: (`char`,))

= Basic
#whiledb(```
n = read_int();
m = n + 1;
write_int(m + 2);
write_char(10)
```, stdins: ("7", "10", "13"))

= Branches
#whiledb(```
var x;
x = read_int();
if (x > 0)
then {
  while (x > 0) do {
    x = x - 1
  }
}
else {
  if (x < 0)
  then {
    write_int(0)
  }
  else {
    write_int(1)
  }
}
```, stdins: ("0", "1", "-1"))

= Prime Judge
#whiledb(```
n = read_int();
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
```, stdins: ("5", "6", "7", "8", "13"))

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
```, stdins: (```
5
1 2 3 4 5
```, ```
10
2 4 6 8 10 12 14 16 18 20
```))

= Abs
#whiledb(```
n = read_int();
if (n >= 0)
then {
  write_int(n)
}
else {
  write_int(- n)
};
write_char(10)
```, stdins: (`-123`, `125`, `-0`, `0`))

= Linked List
#whiledb(```
var n;
var i;
var p;
var q;
var s;
n = read_int();
i = 0;
p = 0;
while (i < n) do {
  q = malloc(2);
  * q = read_int();
  * (q + 1) = p;
  p = q;
  i = i + 1
};
s = 0;
while (p != 0) do {
  s = s + * p;
  p = * (p + 1)
};
write_int(s);
write_char(10)
```, stdins: ("1 1", "2 2 4", "3 3 3 3"))