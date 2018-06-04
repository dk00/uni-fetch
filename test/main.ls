import \../src/index : uni-fetch

function test-response t
  r =
    headers: 'Content-Type': 'application/json'
    json: -> Promise.resolve value: 1

  global.fetch = (...args) -> Promise.resolve r

  actual = await uni-fetch '/'
  expected = value: 1
  t.same actual, expected, 'convert response JSON to object'

  t.end!

function main t
  global.fetch = (...args) ->
    Promise.resolve Object.assign [] args, headers: {}
  global.URL = require \url .URL
  global.URLSearchParams = require \url .URLSearchParams

  [url] = await uni-fetch '/user?id=12345'

  actual = url
  expected = url
  t.is actual, expected, 'pass original url to fetch'

  [url] = await uni-fetch 'https://api.com/user' data: id: \12345

  actual = url.to-string!
  expected = 'https://api.com/user?id=12345'
  t.same actual, expected, 'add data as search parameters'

  [url, init] = await uni-fetch '/user' mode: \no-cors data:
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

  actual = init?mode
  expected = \no-cors
  t.is actual, expected, 'pass other options'

  data = value: 1
  headers = Authorization: \q

  [url, init] = await uni-fetch '/user' {method: \post headers, data}

  actual = url
  expected = '/user'
  t.is actual, expected, 'pass request URL'

  actual = init.method
  expected = \post
  t.is actual, expected, 'pass request method'

  actual = init.headers?'Content-Type'
  expected = 'application/json'
  t.is actual, expected, 'content type for json request body'

  actual = init.headers?'Authorization'
  expected = \q
  t.is actual, expected, 'merge header values'

  actual = init.body
  expected = JSON.stringify value: 1
  t.is actual, expected, 'pack JSON request body'

  data = value: 1 nested: array: [2]
  [, init] = await uni-fetch \user {request-type: \urlencoded data}

  actual = init.method.to-lower-case!
  expected = \post
  t.is actual, expected, 'method defaults to post if having request body'

  actual = init.headers?'Content-Type'
  expected = 'application/x-www-urlencoded'
  t.is actual, expected, 'content type for urlencoded request body'

  actual = decode-URI-component init.body.to-string!
  expected = 'value=1&nested[array][0]=2'
  t.is actual, expected, 'send data as form urlencoded'
  t.test test-response, 'Smart response'

  t.end!

export default: main
