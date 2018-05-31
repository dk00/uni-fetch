# uni-fetch

Yet another convenient wrapper around fetch, for browser and node.js.

[![build status](https://travis-ci.org/dk00/uni-fetch.svg)](https://travis-ci.org/dk00/uni-fetch)
[![coverage](https://codecov.io/gh/dk00/uni-fetch/branch/master/graph/badge.svg)](https://codecov.io/gh/dk00/uni-fetch)
[![npm](https://img.shields.io/npm/v/uni-fetch.svg)](https://npm.im/uni-fetch)
[![dependencies](https://david-dm.org/dk00/uni-fetch/status.svg)](https://david-dm.org/dk00/uni-fetch)

## Why

- `fetch` is good, but not easy enough.
- minimal code for modern browsers. `axios` is still too big(5kb gzipped).

## Installing

Using npm:

`$ npm i -D uni-fetch`

Using cdn:

`<script src="https://unpkg.com/uni-fetch/dist/index.js"></script>`

## Example

Performing a `GET` request

```js
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

## Search Parameters / Query String

`data` is sent as search parameters when making a `GET` request.

Values in `data` are merged with existing parameters in `url`

Nested objects and arrays are packed into query strings properly, so that `req.query` of `express` is the same values of `data`.

## Request Config

- `data`: the data to be sent as search parameters(`GET`) or the request body(other method).
