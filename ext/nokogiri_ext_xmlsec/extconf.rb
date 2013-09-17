require 'mkmf'

def barf message = 'dependencies not met'
  raise message
end

barf unless have_header('ruby.h')

unless pkg_config('xmlsec1-openssl')
  pkg_config('xmlsec1')
end
# HACK 'openssl' is escaped too many times, I don't know why
if $CFLAGS =~ /\-DXMLSEC_CRYPTO=\\\\\\"openssl\\\\\\"/
  $CFLAGS['-DXMLSEC_CRYPTO=\\\\\\"openssl\\\\\\"'] =
    '-DXMLSEC_CRYPTO=\\"openssl\\"'
end
$CFLAGS += " -DXMLSEC_CRYPTO_OPENSSL"

unless have_library 'xmlsec1-openssl'
  have_library 'xmlsec1'
end

$LDFLAGS.gsub!('-lxmlsec1-openssl', '-Wl,-static -lxmlsec1-openssl -Wl,-shared')
create_makefile('nokogiri_ext_xmlsec')

