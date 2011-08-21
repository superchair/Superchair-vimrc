XPTemplate priority=personal

let s:f = g:XPTfuncs()

XPTvar $TRUE           1
XPTvar $FALSE          0
XPTvar $NULL           NULL

XPTvar $BRif           ' '
XPTvar $BRloop         ' '
XPTvar $BRstc          ' '
XPTvar $BRfun          \n

XPTvar $VOID_LINE      /* void */;
XPTvar $CURSOR_PH      /* cursor */

XPTvar $CL  /*
XPTvar $CM   *
XPTvar $CR   */
XPTinclude
      \ _common/common


" ========================= Function and Variables =============================

fun! s:f.c_fun_type_indent()
    return ""
endfunction

fun! s:f.c_fun_body_indent()
    return " "
endfunction

" ================================= Snippets ===================================



XPT main hint=main\ (argc,\ argv)
int main(int argc, char **argv)`$BRfun^{
    `cursor^
    return 0;
}
..XPT

XPT fun wrap=curosr	hint=func..\ (\ ..\ )\ {...
XSET param|def=$CL no parameters $CR
XSET param|post=Echo( V() == $CL . " no parameters " . $CR ? '' : V() )
`int^ `name^(`param^)`$BRfun^{
    `cursor^
}

