import \../src/index : {uni-fetch}

function main t
  global.fetch = (...args) -> args
  global.URL = require \url .URL

  [url] = uni-fetch '/user?id=12345'

  actual = url
  expected = url
  t.is actual, expected, 'pass original url to fetch'

  [url] = uni-fetch '/user' data: id: \12345

  actual = url.to-string!
  expected = '/user?id=12345'
  t.same actual, expected, 'add data as search parameters'

  [url, init] = uni-fetch '/user' data:
    deeply: nested:
      object: \value
      array: [1 value: 2]

  parts = decode-URI-component url .split /[\&\?]/g

  actual = parts.1
  expected = 'deeply[nested][object]=value'
  t.is actual, expected, 'pack object values into query strings'

  actual = parts.2
  expected = 'deeply[nested][array][0]=1'
  t.is actual, expected, 'pack array values into query strings'

  actual = parts.3
  expected = 'deeply[nested][array][1][value]=2'
  t.is actual, expected, 'pack nested object values'

  actual = init?headers
  t.false actual, 'no additional headers for GET'

  [url, init] = uni-fetch '/user' method: \post data: value: 1

  actual = url
  expected = '/user'
  t.is actual, expected, 'pass request URL'

  actual = init.method
  expected = \post
  t.is actual, expected, 'pass request method'

  actual = init.headers?'Content-Type'
  expected = 'application/json'
  t.is actual, expected, 'add content type for json request body'

  actual = init.body
  expected = JSON.stringify value: 1
  t.is actual, expected, 'pack JSON request body'


  #Content-Type is automatically set for string, FormData, URLSearchParams

  t.end!

export default: main
