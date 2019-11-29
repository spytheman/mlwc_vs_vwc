import os

fn C.isspace(int) int
fn C.isprint(int) int

struct State {
mut:
  was_nl bool
  was_wordchar bool
}

[inline] fn is_nl(c byte)    bool { return (c == `\n`) }
[inline] fn is_wordchar(c byte) bool { return C.isprint(c)!=0 && C.isspace(c)==0 }

fn main(){
  data := os.read_file(os.args[1]) or { panic(err) }
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
  
  println('$newlines $words $total')
}
