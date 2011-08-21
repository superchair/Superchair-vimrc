" Make sure the Vim was compiled with +python before loading the script...
if !has("python")
        finish
endif

" Map a keystroke for Visual Mode only (default:F2)
:vmap <f2> :PasteCode<cr>

:command! -range -nargs=* PasteCode :call PasteMe(<line1>,<line2>,"None")

function! PasteMe(line1,line2,args)
python << EOF
import vim

line1 = vim.eval('a:line1')
line2 = vim.eval('a:line2')
jid = vim.eval('a:args')
format = vim.eval('&ft')

url = PBSend(line1, line2, format)
print "Pasted at %s" % url
EOF
endfunction

python << EOF
import vim
from urllib2 import urlopen
from re import compile

def PBSend(line1, line2, format='text'):
################### BEGIN USER CONFIG ###################
    # Set this to your preferred pastebin
    pastebin = 'http://cabuntu2.us.nds.com/paste/index.php'
    # Set this to your preferred username
    user = 'dcraven'
#################### END USER CONFIG ####################

    supported_formats = {
        'text' : 'text', 'bash' : 'bash', 'python' : 'python', 'c' : 'c',
        'cpp' : 'cpp-qt', 'html' : 'html4strict', 'java' : 'java',
        'javascript' : 'javascript', 'perl' : 'perl', 'php' : 'php',
        'sql' : 'sql', 'ada' : 'ada', 'apache' : 'apache', 'asm' : 'asm',
        'aspvbs' : 'asp', 'dcl' : 'caddcl', 'lisp' : 'lisp', 'cs' : 'csharp',
        'css' : 'css', 'lua' : 'lua', 'masm' : 'mpasm', 'nsis' : 'nsis',
        'objc' : 'objc', 'ora' : 'oracle8', 'pascal' : 'pascal',
        'basic' : 'qbasic', 'smarty' : 'smarty', 'vb' : 'vb', 'vim' : 'vim', 'xml' : 'xml'
    }

    if not (pastebin[:7] == 'http://'):
        pastebin = 'http://' + pastebin

    code = '\n'.join(vim.current.buffer[int(line1)-1:int(line2)])
    if format in supported_formats.keys():
        data = "vimpaste=yessir&format=%s&paste=Submit&code2=%s&poster=%s" % \
                (supported_formats[format], urlencode(code),
                urlencode(user))
    else:
        data = "vimpaste=yessir&format=text&paste=Submit&code2=%s&poster=%s" % \
                (urlencode(code), urlencode(user))

    u = urlopen(pastebin, data)
    f = "".join(u.readlines())
    if len(f) > 0:
        url = pastebin + '?show=' + f 
        return url
    else:
        print 'An error occured.'

def urlencode(data):
    out = ""
    for char in data:
        if char.isalnum() or char in ['-','_']:
            out += char
        else:
            char = hex(ord(char))[2:]
            if len(char) == 1:
                char = "0" + char
            out += "%" + char
    return out
EOF
