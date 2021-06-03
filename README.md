## Puppy - Fetch url resources via HTTP and HTTPS.

Getting content from a url should be as easy as `readFile`.

![Github Actions](https://github.com/treeform/puppy/workflows/Github%20Actions/badge.svg)

`nimble install puppy`

Puppy does not use Nim's HTTP stack, instead it uses `win32 WinHttp` API on Windows and `libcurl` on Linux and macOS. Because Puppy uses system APIs, there is no need to ship extra `*.dll`s, `cacert.pem`, or forget to pass the `-d:ssl` flag.

Furthermore, Puppy supports gzip transparently right out of the box.

*Will not support async*

```nim
import puppy

echo fetch("http://neverssl.com/")
```

Will return `""` if any error accrued for any reason.

Need to pass headers?

```nim
import puppy

echo fetch(
  "http://neverssl.com/",
  headers = @[Header(key: "User-Agent", value: "Nim 1.0")]
)
```

Need a more complex API?
* verbs: GET, POST, PUT, UPDATE, DELETE..
* headers: User-Agent, Content-Type..
* response code: 200, 404, 500..
* response headers: Content-Type..
* error: timeout, DNS fail ...

Use request/response instead.

```nim
Request* = ref object
  url*: Url
  headers*: seq[Header]
  verb*: string
  body*: string

Response* = ref object
  url*: Url
  headers*: seq[Header]
  code*: int
  body*: string
  error*: string
```

Usage example:

```nim
let req = Request(
  url: parseUrl("http://www.istrolid.com"),
  verb: "get",
  headers: @[Header(key: "Auth", value: "1"))]
)
let res = fetch(req)
echo res.error
echo res.code
echo res.headers
echo res.body.len
```
