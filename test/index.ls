function test units, dirname
  require \livescript
  tape = require \tape
  register = require \../register
  register if process.env.NYC_CONFIG then plugins: [\istanbul] else []
  tape (require \./main .default), \Fetch

test!
