// Day 4 written in TypeScript using Deno

import { BufReader } from "https://deno.land/std@0.79.0/io/bufio.ts";

// Lets try writing this functionally

const validcolors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"];

interface PassportFields {
  byr?: number; // number >= 1920 and <= 2002
  iyr?: number; // number >= 2010 and <= 2020
  eyr?: number; // number >= 2020 and <= 2030
  hgt?: string; // Ends in "cm" or "in", 193 <= cm >= 150, 76 <= in >= 59
  hcl?: string; // "#{str}" where str is six characters 0-9 or a-f
  ecl?: string; // "amb" | "blu" | "brn" | "gry" | "grn" | "hzl" | "oth"
  pid?: string; // nine digit number
  cid?: string; // ignored
}

type Passport = { [key: string]: string };

const isvalidp1 = (p: PassportFields): 0 | 1 =>
  p.byr && p.iyr && p.eyr && p.hgt && p.hcl && p.ecl && p.ecl && p.pid ? 1 : 0;

const isvalidp2 = (p: PassportFields): 0 | 1 =>
  p.byr && p.byr >= 1920 && p.byr <= 2002 &&
    p.iyr && p.iyr >= 2010 && p.iyr <= 2020 &&
    p.eyr && p.eyr >= 2020 && p.eyr <= 2030 &&
    p.hgt &&
    ((p.hgt.slice(p.hgt.length - 2) === "cm" &&
      Number(p.hgt.slice(0, p.hgt.length - 2)) >= 150 &&
      Number(p.hgt.slice(0, p.hgt.length - 2)) <= 193) ||
      (p.hgt.slice(p.hgt.length - 2) === "in") &&
        Number(p.hgt.slice(0, p.hgt.length - 2)) >= 59 &&
        Number(p.hgt.slice(0, p.hgt.length - 2)) <= 76) &&
    p.hcl && p.hcl[0] == "#" && !isNaN(Number("0x".concat(p.hcl.slice(1)))) &&
    p.ecl && validcolors.includes(p.ecl) &&
    p.pid && p.pid.length === 9 && !isNaN(Number(p.pid))
    ? 1
    : 0;

const countvalid = (
  ps: Passport[],
  validate: (p: Passport) => 0 | 1,
  valid = 0,
): number =>
  ps.length
    ? countvalid(ps.slice(1), validate, valid + validate(ps[0]))
    : valid;

// How to parse input
const stdinreader = BufReader.create(Deno.stdin);

const parseline = (line: string, p: Passport = {}): Passport => {
  if (line.includes(":")) {
    p[line.slice(0, line.indexOf(":"))] = line.slice(
      line.indexOf(":") + 1,
      line.indexOf(" "),
    );
    return parseline(line.slice(line.indexOf(" ") + 1), p);
  } else {
    return p;
  }
};

const isempty = (o: Record<string, unknown>): boolean =>
  Object.keys(o).length === 0;

const getpassports = async (
  ps: Passport[],
  curp?: Passport,
): Promise<Passport[]> => {
  const line = await stdinreader.readString("\n");
  if (line == null) {
    throw new Error("Line could not be read");
  }
  // This makes it easier to parse
  const spaceline = line.slice(0, line.length - 1).concat(" ");
  const p = parseline(spaceline);
  if (!isempty(p) && curp) {
    return getpassports(ps, { ...curp, ...p });
  } else if (!isempty(p)) {
    return getpassports(ps, p);
  } else if (curp) {
    return getpassports(ps.concat(curp));
  } else {
    return ps;
  }
};

// Now do things
console.log(countvalid(await getpassports([]), isvalidp2));

// TS or JS really needs better pattern matching in order for strict fp to be
// readable.
