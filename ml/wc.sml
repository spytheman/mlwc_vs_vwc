(* Source author (bitmapper on v's discord server): https://gist.github.com/bitmappergit/cb8d00eecf7edcbfdd193fc8e0585aca *)

datatype result = T | F | N

fun isWs (SOME x) = (case (Char.isSpace x) of true => T | false => F)
  | isWs (NONE)   = N

fun isNl (SOME #"\n") = T
  | isNl (SOME _)     = F
  | isNl (NONE)       = N

fun wc stream = let
  fun tmp (a, b, c, q) = let
    val input = TextIO.input1 stream
  in
    case (isWs input, isNl input, q) of
      (F, F, T) => tmp (a,   b+1, c+1, F)
    | (F, F, F) => tmp (a,   b,   c+1, q)
    | (T, T, F) => tmp (a+1, b,   c+1, T)
    | (T, T, T) => tmp (a+1, b,   c+1, T)
    | (T, F, F) => tmp (a,   b,   c+1, T)
    | (T, F, T) => tmp (a,   b,   c+1, q)
    | (_, _, _) =>     [a,   b+1, c]
  end
in tmp (0, 0, 0, F) end

fun pr x file =
  (map (fn y => (print y; print " "))
       (map Int.toString x);
   map print [file, "\n"])

val _ = OS.Process.exit let
  val fileName = hd (CommandLine.arguments ())
  val file = TextIO.openIn fileName
  val _ = pr (wc file) fileName
in OS.Process.success end
