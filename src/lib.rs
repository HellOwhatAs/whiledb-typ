use nom::{character::complete as c, sequence::preceded, IResult};
use nom_learn::{parse_cmd, DefinedFunc, Mem};
use std::{cell::RefCell, collections::HashMap, fmt::Write};
use wasm_minimal_protocol::*;

initiate_protocol!();

#[wasm_func]
pub fn whiledb_exec(input: &[u8], stdin: &[u8]) -> Vec<u8> {
    match _whiledb_exec(input, stdin) {
        Ok(mut res) => {
            res.push(0);
            res
        }
        Err(msg) => {
            let mut res = msg.as_bytes().to_vec();
            res.push(1);
            res
        }
    }
}

fn _whiledb_exec(input: &[u8], stdin: &[u8]) -> Result<Vec<u8>, String> {
    let src = std::str::from_utf8(input).map_err(|op| format!("Invalid UTF-8: {}", op))?;
    let buf = RefCell::new(String::new());
    let stdin = std::str::from_utf8(stdin)
        .map_err(|op| format!("Invalid UTF-8: {}", op))?
        .to_owned();
    let stdin_idx = RefCell::new(0usize);
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
        callables.insert(
            "read_int",
            Box::new(|_| {
                let mut idx = stdin_idx.borrow_mut();
                let (rem, res) = parse_i128(&stdin[*idx..]).map_err(|e| e.to_string())?;
                *idx = stdin.len() - rem.len();
                Ok(res)
            }),
        );
        callables.insert(
            "read_char",
            Box::new(|_| {
                let mut idx = stdin_idx.borrow_mut();
                let (rem, res) = parse_char(&stdin[*idx..]).map_err(|e| e.to_string())?;
                *idx = stdin.len() - rem.len();
                Ok(res as i128)
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

pub fn parse_i128(input: &str) -> IResult<&str, i128> {
    preceded(c::multispace0, c::i128)(input)
}

pub fn parse_char(input: &str) -> IResult<&str, char> {
    preceded(c::multispace0, c::anychar)(input)
}
