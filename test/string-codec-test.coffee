assert = require 'power-assert'
sinon = require 'sinon'
codec = require '../../lib/string-codec'

encode_testset =
  'hex':
    'abc':'616263'
    'def':'646566'
    'ghi':'676869'
    'あいうえお':'e38182e38184e38186e38188e3818a'
  'ascii':
    '616263':'abc'
    '0x616263':'abc'
    '61:62:63':'abc'
  'base64':
    'abc':'YWJj'
    'def':'ZGVm'
    'ghi':'Z2hp'
  'ascii85':
    'abc':'<~@:E^~>'
  'base91':
    '0f009e812822216414e849e10bd2f128e127dbe2455c05782c51ecf1b8b00b':'PASSWORD/IS/WHICH+ENCODING+DO+YOU+LIKE'
    '0x0f009e812822216414e849e10bd2f128e127dbe2455c05782c51ecf1b8b00b':'PASSWORD/IS/WHICH+ENCODING+DO+YOU+LIKE'
    '0f:00:9e:81:28:22:21:64:14:e8:49:e1:0b:d2:f1:28:e1:27:db:e2:45:5c:05:78:2c:51:ec:f1:b8:b0:0b':'PASSWORD/IS/WHICH+ENCODING+DO+YOU+LIKE'
  'rot5':
    'abc123':'abc678'
  'rot13':
    'abc':'nop'
  'rot18':
    'abc123':'nop678'
  'rot47':
    'abc':'234'
  'rev':
    'abc':'cba'
  'z85':
    'abc':'vpAZ'
  'rfc1924':
    '2001:db8:100:f101::1':'9R}vSQZ1W=8fRv3*HAqn'
  'crc1':
    'abc':'26'
  'crc8':
    'abc':'5f'
  'crc16':
    'abc':'9738'
  'crc24':
    'abc':'ba1c7b'
  'crc32':
    'abc':'352441c2'
  'adler32':
    'abc':'24d0127'
  'url':
    'あいうえお':'%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A'
  'unixtime':
    'Sun Feb 22 2015 13:40:00 GMT+0900 (JST)':'1424580000000'
  'md4':
    'abc':'a448017aaf21d8525fc10ae87aa6729d'
  'md5':
    'abc':'900150983cd24fb0d6963f7d28e17f72'
  'sha':
    'abc':'0164b8a914cd2a5e74c4f7ff082c4d97f1edf880'
  'sha1':
    'abc':'a9993e364706816aba3e25717850c26c9cd0d89d'
  'sha512':
    'abc':'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f'
  'rmd160':
    'abc':'8eb208f7e05d987a9b044a8e98c6b087f15a0bfc'
  'whirlpool':
    'abc':'4e2448a4c6f486bb16b6562c73b4020bf3043e3a731bce721ae1b303d97e6d4c7181eebdb6c57e277d0e34957114cbd6c797fc9d95d8b582d225292076d4eef5'
  'sha224':
    'abc':'23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7'
  'sha256':
    'abc':'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'
  'sha384':
    'abc':'cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7'
  'sha512':
    'abc':'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f'

decode_testset =
  'hex':
    '616263':'abc'
    '646566':'def'
    '676869':'ghi'
    'e38182e38184e38186e38188e3818a':'あいうえお'
  'ascii':
    'abc':'616263'
  'base64':
    'YWJj':'abc'
    'ZGVm':'def'
    'Z2hp':'ghi'
  'ascii85':
    '<~@:E^~>':'abc'
  'base91':
    'PASSWORD/IS/WHICH+ENCODING+DO+YOU+LIKE':'0f009e812822216414e849e10bd2f128e127dbe2455c05782c51ecf1b8b00b'
  'rot5':
    'abc678':'abc123'
  'rot13':
    'nop':'abc'
  'rot18':
    'nop678':'abc123'
  'rot47':
    '234':'abc'
  'rev':
    'cba':'abc'
  'z85':
    'vpAZ':'abc'
  'rfc1924':
    '9R}vSQZ1W=8fRv3*HAqn':'2001:db8:100:f101::1'
  'url':
    '%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A':'あいうえお'
  # depends on local timezone
  # 'unixtime':
  #   '1424580000000':'Sun Feb 22 2015 13:40:00 GMT+0900 (JST)'
  # require internet connection
  # 'md5':
  #   '5d41402abc4b2a76b9719d911017c592':'hello'


describe 'encode test', ->
  for algo, testset of encode_testset
    do (algo, testset) ->
      for key, value of testset
        do (key, value) ->
          it algo + ': ' + key + ' -> ' + value, ->
            assert codec.encoder(key, algo) is value

describe 'decode test', ->
  for algo, testset of decode_testset
    do (algo, testset) ->
      for key, value of testset
        do (key, value) ->
          it algo + ': ' + key + ' -> ' + value, ->
            assert codec.decoder(key, algo) is value
