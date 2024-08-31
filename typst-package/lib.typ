#let whiledb-wasm = plugin("whiledb_typ.wasm")
#let whiledb_exec(src) = {
  let res = whiledb-wasm.whiledb_exec(if type(src) == str {
    bytes(src)
  } else {
    bytes(src.text)
  });
  let err_flag = res.at(res.len() - 1) != 0;
  let result = str(res.slice(0, count: res.len() - 1));
  (err: err_flag, result: result)
}