function expand-entries data
  parameters = Object.entries data .map ([key, value]) ->
    if value && typeof value == \object
      expand-entries value .map ({key: sub, value: sub-value}) ->
        key: [key]concat sub
        value: sub-value
    else {key, value}
  []concat ...parameters

function query-key key
  [first, ...rest] = []concat key
  [first]concat rest.map -> "[#it]"
  .join ''

function add-entries params, data
  expand-entries data .for-each ({key, value}) ->
    params.set (query-key key), value
  params

function with-params url, data
  if !data then url
  else
    prefix = if url.includes '://' then '' else 'http://q/'
    merged = new URL prefix + url
    add-entries merged.search-params, data
    if prefix then merged.to-string!slice prefix.length else merged

function have-request-body method
  method && !/get|head|option/test method

function request-method {method, request-type} => switch
  | method => method.to-lower-case!
  | request-type => \post

function create-search-params data
  add-entries new URLSearchParams, data

content-types =
  json: 'application/json'
  urlencoded: 'application/x-www-urlencoded'

encode =
  json: -> JSON.stringify it
  urlencoded: create-search-params

function request-body {data, request-type=\json}
  headers:
    'Content-Type': content-types[request-type]
  body: encode[request-type] data

function uni-fetch url, {headers, data}: options={}
  method = request-method options
  final-url = if have-request-body method then url
  else with-params url, data
  if have-request-body method
    {body, headers: base-headers} = request-body options

  fetch final-url, Object.assign {body},
    if method then {method}
    options
    if headers || base-headers
      headers: Object.assign {} base-headers, headers

export {default: uni-fetch, uni-fetch}
