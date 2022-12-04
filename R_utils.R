##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title 
##' @param doc_lines 
##' @param doc_cursor_line 
##' @return 
##' @author Justin Silverman
##' @import breakerofchains
##' @export
ess_break_chains <- function(doc_lines, doc_cursor_line,
                             print_result=TRUE, assign_result=TRUE) {

  print(doc_lines)
  print(doc_cursor_line)
  truncated_context <-
    breakerofchains:::truncate_to_chunk_boundary(doc_lines, doc_cursor_line)

  broken_chain <- breakerofchains::get_broken_chain(truncated_context$text, truncated_context$line_number)

  breakerofchains:::print_chain_code(broken_chain)

  calling_env <- parent.frame()
  .chain <- eval(parse(text = broken_chain), envir = calling_env)
  if (print_result) print(.chain)

  if (assign_result) assign(".chain", .chain, .GlobalEnv)
  invisible(.chain)
}
