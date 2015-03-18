'use strict'

crc = require 'crc'
crypto = require 'crypto'
ascii85 = require 'ascii85'
base91 = require '../lib/base91'
caesar = require 'caesar-salad'
adler32 = require 'adler-32'
cheerio = require 'cheerio'
request = require 'sync-request'

allencoder = []
encalgos = ['hex', 'ascii', 'base64', 'base85', 'z85', 'ascii85', 'base91',
            'rot5', 'rot13', 'rot18', 'rot47', 'rev', 'crc1', 'crc8', 'crc16',
            'crc24', 'crc32', 'adler32', 'url', 'unixtime', 'lower', 'upper']
enchashes = ['md4', 'md5', 'sha', 'sha1', 'sha224', 'sha256', 'sha384',
             'sha512', 'rmd160', 'whirlpool']
allenchashes = enchashes.concat(crypto.getHashes())
# dedupe
allenchashes = allenchashes.filter((x, i, self) -> self.indexOf(x) is i)
allencoder = allencoder.concat(encalgos,allenchashes)

alldecoder = []
decalgos = ['hex', 'ascii', 'base64', 'base85', 'z85', 'ascii85', 'base91',
            'rot5', 'rot13', 'rot18', 'rot47', 'rev', 'url', 'unixtime']
dechashes = ['md5']
alldecoder = alldecoder.concat(decalgos,dechashes)

module.exports =
  ENC_ALGOS:  encalgos[..]
  ENC_HASHES: allenchashes[..]
  ENC_ALL:    allencoder[..]
  DEC_ALGOS:  decalgos[..]
  DEC_HASHES: dechashes[..]
  DEC_ALL:    alldecoder[..]

# hex parse helper
hex_parse = (str) ->
  hex = str.replace(/0x|:/g, '')
  if not (hex.length % 2)
    hex
  else
    false

# rot helper
rotX = (algo) ->
  (str) ->
    caesar[algo].Cipher().crypt(str)

# reverse string
rev = (str) ->
  str.split('').reverse().join('')

# reciprocal cipher helper
recipro = {
  rot5: rotX('ROT5'),
  rot13: rotX('ROT13'),
  rot18: rotX('ROT18'),
  rot47: rotX('ROT47'),
  rev: rev
}

# md5 decrypter
decmd5 = (str) ->
  baseUrl = 'http://www.md5-hash.com/md5-hashing-decrypt/'
  try
    res = request('GET', baseUrl + str)
  catch error
    return error
  $ = cheerio.load res.getBody('utf8')
  ret_str = $('strong.result').text()
  if str is encoder(ret_str,'md5')
    ret_str
  else
    'not found'

# decrypter helper
decrypter = {
  md5: decmd5
}


# encode helper
module.exports.encoder = (str, algo) ->
  switch algo
    when 'hex', 'base64'
      new Buffer(str).toString(algo)
    when 'ascii85'
      ascii85.PostScript.encode(str)
    when 'base91'
      if hex = hex_parse(str)
        base91.encode(Buffer(hex, 'hex')).toString('utf8')
    when 'ascii'
      if hex = hex_parse(str)
        Buffer(hex, 'hex').toString('utf8')
    when 'rot5', 'rot13', 'rot18', 'rot47', 'rev'
      recipro[algo](str)
    when 'base85', 'z85'
      ascii85.ZeroMQ.encode(str)
    when 'crc1', 'crc8', 'crc16', 'crc24', 'crc32'
      crc[algo](str).toString(16)
    when 'adler32'
      adler32.str(str).toString(16)
    when 'url'
      encodeURIComponent(str)
    when 'unixtime'
      Date.parse(str).toString(10)
    when 'lower'
      str.toLowerCase()
    when 'upper'
      str.toUpperCase()
    else
      if algo in allenchashes
        crypto.createHash(algo).update(str, 'utf8').digest('hex')
      else
        'Error: unknown algorithm specified'


# decode helper
module.exports.decoder = (str, algo) ->
  switch algo
    when 'hex'
      if not (str.length % 2)
        new Buffer(str, algo).toString('utf8')
    when 'base64'
      new Buffer(str, algo).toString('utf8')
    when 'ascii85'
      ascii85.decode(str).toString('utf8')
    when 'base91'
      base91.decode(str).toString('hex')
    when 'ascii'
      new Buffer(str, algo).toString('hex')
    when 'rot5', 'rot13', 'rot18', 'rot47', 'rev'
      recipro[algo](str)
    when 'base85', 'z85'
      ascii85.ZeroMQ.decode(str).toString('utf8')
    when 'url'
      decodeURIComponent(str)
    when 'unixtime'
      new Date(parseInt(str)).toString('utf8')
    when 'md5'
      decrypter[algo](str)
    else
      'Error: unknown algorithm specified'
