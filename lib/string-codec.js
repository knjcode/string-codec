'use strict';
var adler32, alldecoder, allenchashes, allencoder, ascii85, base91, caesar, cheerio, crc, crypto, decalgos, dechashes, decmd5, decrypter, encalgos, enchashes, hex_parse, recipro, request, rev, rotX,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

crc = require('crc');

crypto = require('crypto');

ascii85 = require('ascii85');

base91 = require('../lib/base91');

caesar = require('caesar-salad');

adler32 = require('adler-32');

cheerio = require('cheerio');

request = require('sync-request');

allencoder = [];

encalgos = ['hex', 'ascii', 'base64', 'base85', 'z85', 'ascii85', 'base91', 'rot5', 'rot13', 'rot18', 'rot47', 'rev', 'crc1', 'crc8', 'crc16', 'crc24', 'crc32', 'adler32', 'url', 'unixtime', 'lower', 'upper'];

enchashes = ['md4', 'md5', 'sha', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512', 'rmd160', 'whirlpool'];

allenchashes = enchashes.concat(crypto.getHashes());

allenchashes = allenchashes.filter(function(x, i, self) {
  return self.indexOf(x) === i;
});

allencoder = allencoder.concat(encalgos, allenchashes);

alldecoder = [];

decalgos = ['hex', 'ascii', 'base64', 'base85', 'z85', 'ascii85', 'base91', 'rot5', 'rot13', 'rot18', 'rot47', 'rev', 'url', 'unixtime'];

dechashes = ['md5'];

alldecoder = alldecoder.concat(decalgos, dechashes);

module.exports = {
  ENC_ALGOS: encalgos.slice(0),
  ENC_HASHES: allenchashes.slice(0),
  ENC_ALL: allencoder.slice(0),
  DEC_ALGOS: decalgos.slice(0),
  DEC_HASHES: dechashes.slice(0),
  DEC_ALL: alldecoder.slice(0)
};

hex_parse = function(str) {
  var hex;
  hex = str.replace(/0x|:/g, '');
  if (!(hex.length % 2)) {
    return hex;
  } else {
    return false;
  }
};

rotX = function(algo) {
  return function(str) {
    return caesar[algo].Cipher().crypt(str);
  };
};

rev = function(str) {
  return str.split('').reverse().join('');
};

recipro = {
  rot5: rotX('ROT5'),
  rot13: rotX('ROT13'),
  rot18: rotX('ROT18'),
  rot47: rotX('ROT47'),
  rev: rev
};

decmd5 = function(str) {
  var $, baseUrl, error, res, ret_str;
  baseUrl = 'http://www.md5-hash.com/md5-hashing-decrypt/';
  try {
    res = request('GET', baseUrl + str);
  } catch (_error) {
    error = _error;
    return error;
  }
  $ = cheerio.load(res.getBody('utf8'));
  ret_str = $('strong.result').text();
  if (str === encoder(ret_str, 'md5')) {
    return ret_str;
  } else {
    return 'not found';
  }
};

decrypter = {
  md5: decmd5
};

module.exports.encoder = function(str, algo) {
  var hex;
  switch (algo) {
    case 'hex':
    case 'base64':
      return new Buffer(str).toString(algo);
    case 'ascii85':
      return ascii85.PostScript.encode(str);
    case 'base91':
      if (hex = hex_parse(str)) {
        return base91.encode(Buffer(hex, 'hex')).toString('utf8');
      }
      break;
    case 'ascii':
      if (hex = hex_parse(str)) {
        return Buffer(hex, 'hex').toString('utf8');
      }
      break;
    case 'rot5':
    case 'rot13':
    case 'rot18':
    case 'rot47':
    case 'rev':
      return recipro[algo](str);
    case 'base85':
    case 'z85':
      return ascii85.ZeroMQ.encode(str);
    case 'crc1':
    case 'crc8':
    case 'crc16':
    case 'crc24':
    case 'crc32':
      return crc[algo](str).toString(16);
    case 'adler32':
      return adler32.str(str).toString(16);
    case 'url':
      return encodeURIComponent(str);
    case 'unixtime':
      return Date.parse(str).toString(10);
    case 'lower':
      return str.toLowerCase();
    case 'upper':
      return str.toUpperCase();
    default:
      if (indexOf.call(allenchashes, algo) >= 0) {
        return crypto.createHash(algo).update(str, 'utf8').digest('hex');
      } else {
        return 'Error: unknown algorithm specified';
      }
  }
};

module.exports.decoder = function(str, algo) {
  switch (algo) {
    case 'hex':
      if (!(str.length % 2)) {
        return new Buffer(str, algo).toString('utf8');
      }
      break;
    case 'base64':
      return new Buffer(str, algo).toString('utf8');
    case 'ascii85':
      return ascii85.decode(str).toString('utf8');
    case 'base91':
      return base91.decode(str).toString('hex');
    case 'ascii':
      return new Buffer(str, algo).toString('hex');
    case 'rot5':
    case 'rot13':
    case 'rot18':
    case 'rot47':
    case 'rev':
      return recipro[algo](str);
    case 'base85':
    case 'z85':
      return ascii85.ZeroMQ.decode(str).toString('utf8');
    case 'url':
      return decodeURIComponent(str);
    case 'unixtime':
      return new Date(parseInt(str)).toString('utf8');
    case 'md5':
      return decrypter[algo](str);
    default:
      return 'Error: unknown algorithm specified';
  }
};
