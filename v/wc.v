import os

struct State {
mut:
  was_nl bool
  was_wordchar bool
}

[inline] fn is_nl(c byte)    bool { return (c == `\n`) }
// taken from musl's isprint && isspace source:
[inline] fn is_wordchar(c byte) bool { return (c-0x20 < 0x5f) && !(c == ` ` || (c - `\t`) < 5 ) } 

fn main(){
  file := os.args[1]
  data := os.read_file(file) or { panic(err) }
  chars := &byte(data.str)
  
  total := data.len
  mut newlines := 0
  mut words := 0
  
  mut ostate := State{ was_nl: true }
  for i := 0; i < total; i++ {
      c := chars[i]
      nstate := State{ was_nl: is_nl(c) was_wordchar: is_wordchar(c) }
      if nstate.was_nl { newlines++ }
      if !ostate.was_wordchar && nstate.was_wordchar { words++ }
      ostate = nstate
  }
  
  println('$newlines $words $total $file')
}
