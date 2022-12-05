#' Wrapper around breakerofchains::get_broken_chain()
#'
#' This is a small wrapper intended to adapt MilesMcBains breakerofchains library for use with
#' emacs and ESS.
#' @param doc_lines an R vector of strings each represneting a line in the file with the chain
#' @param doc_cursor_line the current line the cursor is on
#' @return .chain an object storing the output of the chain unless assign_result=FALSE
#' @author Justin Silverman
#' @import breakerofchains
#' @export ess_break_chains
ess_break_chains <- function(doc_lines, doc_cursor_line,
                             print_result=TRUE, assign_result=TRUE) {

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
