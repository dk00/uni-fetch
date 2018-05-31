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

function with-params url, data
  if !data then url
  else
    prefix = if url.includes '://' then '' else 'http://q/'
    merged = new URL prefix + url
    expand-entries data .for-each ({key, value}) ->
      merged.search-params.set (query-key key), value
    if prefix then merged.to-string!slice prefix.length else merged

function have-request-body {method}={}
  method && method.to-lower-case! != \get

function uni-fetch url, {method, data}: options={}
  final-url = if have-request-body options then url else with-params url, data

  fetch final-url, Object.assign {},
    if method then {method}
    if have-request-body options
      headers: 'Content-Type': 'application/json'
      body: JSON.stringify data

export {default: uni-fetch, uni-fetch}
