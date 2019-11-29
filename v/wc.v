import os

struct State {
mut:
  was_nl bool
  was_space bool
  was_alnum bool
}

[inline] fn is_nl(c byte)    bool { return (c == `\n`) }
[inline] fn is_ws(c byte)    bool { return (c == ` ` || c == `\t` ) }
[inline] fn is_alnum(c byte) bool { return (c >= `a` && c <= `z`) || (c>=`A` && c<= `Z`) }

fn main(){
  data := os.read_file(os.args[1]) or { panic(err) }
  chars := &byte(data.str)
  
  total := data.len
  mut newlines := 0
  mut spaces := 0 
  mut words := 0
  
  mut ostate := State{ was_nl: true }
  for i := 0; i < total; i++ {
      c := chars[i]
      nstate := State{ was_nl: is_nl(c) was_space: is_ws(c) was_alnum: is_alnum(c) }
      if nstate.was_nl { newlines++ }
      if nstate.was_space { spaces++ }
      if !ostate.was_alnum && nstate.was_alnum  { words++ }
      ostate = nstate
  }
  
  println('$newlines $words $total')
}
