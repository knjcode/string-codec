# string-codec

[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url]

Encoder/Decoder of various algorithm

## Installation

via [npm (node package manager)](http://github.com/npm/npm)

    $ npm install string-codec

## Usage Example

Encode to Base64:

    var codec = require('string-codec');
    
    codec.encoder('hello','base64');
    // => 'aGVsbG8='

Decode from Base64:

    var codec = require('string-codec');
    
    codec.decoder('aGVsbG8=','base64')
    // => 'hello'

List supported algorithm

    var codec = require('string-codec');
    
    // list array of encoding algorithm
    codec.ENC_ALGOS
    // => ["hex","ascii","base64","base85","z85","ascii85","base91","rot5",
           "rot13", "rot18", "rot47","rev","crc1","crc8","crc16","crc24",
           "crc32","adler32","url","unixtime","lower","upper"]
    
    // list array of decoding algorithm
    codec.DEC_ALGOS
    // => ["hex","ascii","base64","base85","z85","ascii85","base91","rot5",
           "rot13","rot18","rot47","rev","url","unixtime"]

## API

** encode(input, algorithm) **

encode input with specified algorithm

** decode(input, algorithm) **

decode input with specified algorithm

** ENC_ALGOS **

list supported encoding algorithm

** ENC_HASHES **

list supported hash algorithm

** ENC_ALL **

list all supported encoding algorithm (ENC_ALGOS + ENC_HASHES)

** DEC_ALGOS **

list supported decoding algorithm

** DEC_HASHES **

list supported hash decryption algorithm

** DEC_ALL **

list all supported decoding algorithm (DEC_ALGOS + DEC_HASHES)

## Supported specifications

### encoder

|algorithm|input|output|
|:--|:--|:--|
|hex|string|hex string|
|ascii|hex string|string|
|base64|string|base64|
|base85 (z85))|string|base85|
|ascii85|string|ascii85|
|base91|hex string|string|
|rot5/rot13/rot18/rot47|string|string|
|rev (reverse string)|string|string|
|crc1/crc8/crc16<br>crc24/crc32|string|crc checksum|
|adler32|string|adler32|
|url (url encoding)|string|url encode|
|unixtime|date string|unix timestamp|
|lower|string|string|
|upper|string|string|
|md4|string|md4|
|md5|string|md5|
|sha|string|sha|
|sha1|string|sha1|
|sha224|string|sha224|
|sha256|string|sha256|
|sha384|string|sha384|
|sha512|string|sha512|
|rmd160|string|rmd160|
|whirlpool|string|whirlpool|

### decoder

|algorithm|input|output|
|:--|:--|:--|
|hex|hex string|string|
|ascii|string|hex string|
|base64|base64|string|
|base85 (z85)|base85|string|
|ascii85|ascii85|string|
|base91|base91|hex string|
|rot5/rot13/rot18/rot47|string|string|
|rev|string|string|
|url|url encode|string|
|unixtime|unix timestamp|date string|
|md5|md5|string|

### Input hex string

Accept hex string prefixed with '0x' or separated by a colon (:)

    codec.decoder('616263','hex');
    // => abc
    codec.decoder('0x616263','hex');
    // => abc
    codec.decoder('61:62:63','hex');
    // => abc
    codec.decoder('0x61:62:63','hex');
    // => abc

## Running tests

    $ git clone https://github.com/knjcode/string-codec.git
    $ cd string-codec
    $ npm install
    $ npm test

## Acknowledgements

- @_rintaro_f
- @inaz2
- basE91 based on [mscdex/base91.js](https://github.com/mscdex/base91.js)
- Ascii85(base85)/z85(ZeroMQ) [huandu/node-ascii85](https://github.com/huandu/node-ascii85)
- rot5/rot13/rot18/rot47 [schnittstabil/caesar-salad](https://github.com/schnittstabil/caesar-salad)
- crc1/crc8/crc16/crc24/crc32 [alexgorbatchev/node-crc](https://github.com/alexgorbatchev/node-crc)
- adler32 [SheetJS/js-adler32](https://github.com/SheetJS/js-adler32)
- MD5 decrypter [MD5-hash.com](http://www.md5-hash.com)

[npm-url]: https://npmjs.org/package/string-codec
[npm-image]: https://badge.fury.io/js/string-codec.svg
[travis-url]: https://travis-ci.org/knjcode/string-codec
[travis-image]: https://travis-ci.org/knjcode/string-codec.svg?branch=master
