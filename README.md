# uni-fetch

Yet another convenient wrapper around fetch, for browser and node.js.

[![build status](https://travis-ci.org/dk00/uni-fetch.svg)](https://travis-ci.org/dk00/uni-fetch)
[![coverage](https://codecov.io/gh/dk00/uni-fetch/branch/master/graph/badge.svg)](https://codecov.io/gh/dk00/uni-fetch)
[![npm](https://img.shields.io/npm/v/uni-fetch.svg)](https://npm.im/uni-fetch)
[![dependencies](https://david-dm.org/dk00/uni-fetch/status.svg)](https://david-dm.org/dk00/uni-fetch)

## Why

- `fetch` is good, but not easy enough
- Minimal code for modern browsers. `axios` is still too big(5kb gzipped)
- Minimal config
- Focused to RESTFul API

## Installing

Using npm:

`$ npm i -D uni-fetch`

Using cdn:

`<script src="https://unpkg.com/uni-fetch/dist/index.js"></script>`

## Example

Performing a `GET` request

```js
import {uniFetch} from 'uni-fetch'

// Make a request for a user with a given id
uniFetch('/user?id=12345')
.then(data => console.log(data))
.catch(error => console.log(error))

// Optionally the request above could also be done as
async getUser = () => {
  try {
    const data = await uniFetch('/user', {
      data: {
        id: 12345
      }
    })
    console.log(data)
  } catch (error) {
    console.error(error)
  }
}
```

## Smart Request Body

If `data` is a plain Javascript object, it will be encoded automatically and sent as search parameters, or request body, based on `method` and `requestType`.

## Smart Search Parameters

When converting `data` to search parameters, nested objects are encoded to be understanded by `express`, so that `req.query` is same as `data`.

> TODO: FormData application/x-www-form-urlencoded
> TODO: base64 encode inner Blob

- `data`: the data to be sent as search parameters(`GET`) or the request body(other method).

## Smart Response

Response body is automatically converted by proper method, based on `Content-Type` of response header. Supported types are:

- `application/json`: `.json`
- `text/plain`: `.text`
- `application/octect-stream`: `.blob`
