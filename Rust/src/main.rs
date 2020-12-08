use std::io;

const COL_BITS: u32 = 7;
const ROW_BITS: u32 = 3;
const COL_0: char = 'F';
const COL_1: char = 'B';
const ROW_0: char = 'L';
const ROW_1: char = 'R';

fn parseline(line: &String) -> (u8, u8) {
    let line_str = line.as_str();
    let mut seat: (u8, u8) = (0, 0);
    for c in line_str[..COL_BITS as usize].chars() {
        seat.0 <<= 1;
        match c {
            COL_0 => {}
            COL_1 => seat.0 += 1,
            _ => panic!("Invalid col character in line: {}", line),
        }
    }
    for c in line_str[COL_BITS as usize..(COL_BITS as usize + ROW_BITS as usize)].chars() {
        seat.1 <<= 1;
        match c {
            ROW_0 => {}
            ROW_1 => seat.1 += 1,
            _ => panic!("Invalid row character in line: {}", line),
        }
    }
    return seat;
}

fn id(seat: (u8, u8)) -> u16 {
    return seat.0 as u16 * 8 + seat.1 as u16;
}

fn _p1(lines: Vec<String>) -> u16 {
    let mut max_id = 0;
    for line in lines.iter() {
        let seat = parseline(line);
        let id = seat.0 as u16 * 8 + seat.1 as u16;
        if id > max_id {
            max_id = id;
        }
    }
    return max_id;
}

fn p2(lines: Vec<String>) -> u16 {
    let mut min_id: u16 = 128 * 8 - 1;
    let mut taken_ids: [u16; 128 * 8] = [0; 128 * 8];
    for line in lines.iter() {
        let id = id(parseline(line));
        min_id = std::cmp::min(min_id, id);
        taken_ids[id as usize] += 1;
    }
    for myid in min_id as usize..taken_ids.len() - 1 {
        if taken_ids[myid] == 0 {
            return myid as u16;
        }
    }
    return min_id;
}

fn main() -> io::Result<()> {
    let stdin = io::stdin();
    let mut lines: Vec<String> = Vec::new();
    // Read and parse each line
    loop {
        let mut line = String::new();
        stdin.read_line(&mut line)?;
        line.pop();
        if line.len() == 0 {
            break;
        }
        lines.push(line);
    }
    println!("{}", p2(lines));
    Ok(())
}
