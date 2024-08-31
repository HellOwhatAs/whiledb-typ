use nom_learn::{parse_cmd, DefinedFunc, Mem};
use std::{cell::RefCell, collections::HashMap, fmt::Write};
use wasm_minimal_protocol::*;

initiate_protocol!();

#[wasm_func]
pub fn whiledb_exec(input: &[u8]) -> Vec<u8> {
    match _whiledb_exec(input) {
        Ok(mut res) => {
            res.push(0);
            res
        },
        Err(msg) => {
            let mut res = msg.as_bytes().to_vec();
            res.push(1);
            res
        }
    }
}

fn _whiledb_exec(input: &[u8]) -> Result<Vec<u8>, String> {
    let src = std::str::from_utf8(input).map_err(|op| format!("Invalid UTF-8: {}", op))?;
    let buf = RefCell::new(String::new());
    {
        let (mut registers, mut mem) = (HashMap::new(), Mem::new());
        let mut callables: HashMap<&str, DefinedFunc> = HashMap::new();
        callables.insert(
            "write_int",
            Box::new(|x| {
                buf.borrow_mut().write_str(&x.to_string())?;
                Ok(x)
            }),
        );
        callables.insert(
            "write_char",
            Box::new(|x| {
                buf.borrow_mut().write_str(&(x as u8 as char).to_string())?;
                Ok(x)
            }),
        );
        let (rem_src, cmd) = parse_cmd(src).map_err(|e| e.to_string())?;
        if rem_src.trim().len() > 0 {
            return Err(rem_src.to_string());
        }
        cmd.exec(&mut registers, &mut mem, &mut callables)
            .map_err(|e| e.to_string())?;
    }
    Ok(buf.take().as_bytes().to_vec())
}