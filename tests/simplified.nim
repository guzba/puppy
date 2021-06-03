import libcurl, strutils

const CRLF = "\r\n"

proc curlWriteFn(
  buffer: cstring,
  size: int,
  count: int,
  outstream: pointer
): int {.cdecl.} =
  let outbuf = cast[ref string](outstream)
  outbuf[] &= buffer
  result = size * count

proc fetch*(url: string) =
  let curl = easy_init()

  discard curl.easy_setopt(OPT_URL, url)
  discard curl.easy_setopt(OPT_CUSTOMREQUEST, "GET")

  # Setup writers.
  var
    headerData: ref string = new string
    bodyData: ref string = new string
  discard curl.easy_setopt(OPT_WRITEDATA, bodyData)
  discard curl.easy_setopt(OPT_WRITEFUNCTION, curlWriteFn)
  discard curl.easy_setopt(OPT_HEADERDATA, headerData)
  discard curl.easy_setopt(OPT_HEADERFUNCTION, curlWriteFn)

  let ret = curl.easy_perform()

  if ret == E_OK:
    var httpCode: uint32
    discard curl.easy_getinfo(INFO_RESPONSE_CODE, httpCode.addr)
    echo headerData != nil
    if headerData != nil:
      echo headerData[]
      for headerLine in headerData[].split(CRLF):
        let arr = headerLine.split(":", 1)
        if arr.len == 2:
          echo (arr[0].strip(), arr[1].strip())
    echo bodyData[]
  else:
    echo $easy_strerror(ret)

  curl.easy_cleanup()

fetch("http://neverssl.com/")
