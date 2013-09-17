require 'mkmf'

def barf message = 'dependencies not met'
  raise message
end

barf unless have_header('ruby.h')

# HACK 'openssl' is escaped too many times, I don't know why
$CFLAGS['-DXMLSEC_CRYPTO=\\\\\\"openssl\\\\\\"'] =
  '-DXMLSEC_CRYPTO=\\"openssl\\"'

have_library 'xmlsec1-openssl'
create_makefile('nokogiri_ext_xmlsec')
