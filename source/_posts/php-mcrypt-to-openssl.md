---
title: PHP加解密算法使用openssl替换mcrypt扩展
tags:
  - PHP
  - openssl
  - mcrypt
  - xtea
abbrlink: 5c3bf0b6
date: 2019-02-20 18:02:20
categories:
---

PHP版本从7.2开始不再支持mcrypt扩展，所以我们需要使用OpenSSl对其进行替换。本文仅列出部分算法的替换示例，所以不在本文出现的算法或模式需要自行尝试，顺水推舟。

本文替换案例：

1. MCRYPT_RIJNDAEL_128 | MCRYPT_MODE_ECB => AES-128-ECB
2. MCRYPT_DES | MCRYPT_MODE_CBC => DES-CBC
3. MCRYPT_RIJNDAEL_128 | MCRYPT_MODE_CBC => AES-128-CBC
4. MCRYPT_XTEA | MCRYPT_MODE_CBC

> 在使用 MCRYPT_RIJNDAEL_128 的地方，如果秘钥长度分别为16、24、32，则加密算法用 AES-128-ECB、AES-192-ECB、AES-256-ECB，BlockSize为16、24、32。

首先列出需要用到的数据填充方法：

```PHP
function ZeroPadding($str, $block = 16) {
    $pad = $block - (strlen($str) % $block);
    if($pad == $block) return $str;
    return $str.str_repeat(chr(0),$pad);
}
function ZeroUnPadding($str) {
    return rtrim($str, "\0");
}
 
 
function PKCS7Padding($str, $block_size) {
    $padding_char = $block_size - (strlen($str) % $block_size);
    $padding_str = str_repeat(chr($padding_char),$padding_char);
    return $str.$padding_str;
}
function PKCS7UnPadding($str) {
    $char=substr($str,-1,1);
    $num=ord($char);
    if($num>0 && $num <= strlen($str)) {
        $str = substr($str, 0, -1 * $num);
    }
    return $str;
}
```
<!--more-->

## 算法MCRYPT_RIJNDAEL_128 | MCRYPT_MODE_ECB 对应 AES-128-ECB

```PHP
//使用mcrypt加密
$data = '1234567890123456';
$key = md5('1230456789', true);
$encrypted = mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $key, $data, MCRYPT_MODE_ECB);
$edata = base64_encode($encrypted);
return $edata;

//使用OpenSSL加密
$data = '1234567890123456';
$key = md5('1230456789', true);
 
$encrypted = openssl_encrypt(ZeroPadding($data, 16), 'AES-128-ECB', $key, OPENSSL_RAW_DATA | OPENSSL_ZERO_PADDING);
$edata = base64_encode($encrypted);
return $edata;

//使用OpenSSL解密
$key = md5('1230456789', true);

$data = openssl_decrypt(base64_decode($edata), 'AES-128-ECB', $key, OPENSSL_RAW_DATA | OPENSSL_ZERO_PADDING);
$data = ZeroUnPadding($data);
return $data;
```

## 算法MCRYPT_DES | MCRYPT_MODE_CBC 对应 DES-CBC

```PHP
//使用mcrypt加密
$data = '1234567890123456';
$key = md5('1230456789', true);
$encrypted = mcrypt_encrypt(MCRYPT_DES, $key, $data, MCRYPT_MODE_CBC, $iv);
$edata = base64_encode($encrypted);
return $edata;

//使用OpenSSL加密：
$data = '1234567890123456';
$key = 'abcd1234';
$iv = 'mds2345&';
 
$encrypted = openssl_encrypt(ZeroPadding($data, 8), 'DES-CBC', $key, OPENSSL_RAW_DATA | OPENSSL_ZERO_PADDING, $iv);
$edata = base64_encode($encrypted);
return $edata;

//使用OpenSSL解密：
$key = 'abcd1234';
$iv = 'mds2345&';
 
$data = openssl_decrypt(base64_decode($edata), 'DES-CBC', $key, OPENSSL_RAW_DATA | OPENSSL_ZERO_PADDING, $iv);
$data = ZeroUnPadding($data);
return $data;
```

## 算法MCRYPT_RIJNDAEL_128 | MCRYPT_MODE_CBC 对应 AES-128-CBC

```PHP
//使用mcrypt加密：
$data = '1234567890123456';
$key = md5('1230456789', true);
$size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
$iv = mcrypt_create_iv($size, MCRYPT_DEV_RANDOM);   //生成随机向量

//对内容进行PKCS7填充
$block_size = mcrypt_get_block_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
$padding_char = $block_size - (count($str) % $block_size);
$padding_str = '';
if($padding_char<=$block_size) {
    $padding_str = str_repeat(chr($padding_char),$padding_char);
}
$str = $str.$padding_str;
 
$encrypted = mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $key, $str, MCRYPT_MODE_CBC, $iv);
$edata = base64_encode($encrypted);
return $edata;

//使用OpenSSL加密：
$data = '1234567890123456';
$key = md5('1230456789', true);
 
 
$ivlen = openssl_cipher_iv_length('AES-128-CBC');
$iv = openssl_random_pseudo_bytes($ivlen);
$str = PKCS7Padding($data, 16);
 
$encrypted = openssl_encrypt($str, 'AES-128-CBC', $key, OPENSSL_RAW_DATA | OPENSSL_ZERO_PADDING, $iv);
$edata = base64_encode($encrypted);
return $edata;

//使用OpenSSL解密：
$key = md5('1230456789', true);
//$iv用加密时生成的同一个iv
$data = openssl_decrypt(base64_decode($edata), 'AES-128-CBC', $key, OPENSSL_RAW_DATA | OPENSSL_ZERO_PADDING, $iv);
$data = PKCS7UnPadding($data);
return $data;
```

## 算法MCRYPT_XTEA | MCRYPT_MODE_CBC 需要使用第三方类的修改版本

```PHP
<?php
// Origin: https://github.com/jungepiraten/nntpboard/blob/master/libs/xtea.class.php
// Modified By imsry.cn
class Xtea
{

    //Private
    var $key;

    // CBC or ECB Mode
    // normaly, CBC Mode would be the right choice
    var $cbc = 1;
    var $iv = null;

//    function Xtea($key)
//    {
//        $this->key_setup($key);
//    }

    function iv_setup($iv){
        $this->iv = $this->_str2long($iv);
    }

    //Verschluesseln
    function encrypt($text)
    {
        $n = strlen($text);
        if ($n % 8 != 0) $lng = ($n + (8 - ($n % 8)));
        else $lng = 0;

        $text = str_pad($text, $lng, "\0");
        $text = $this->_str2long($text);
        $cipher = array();

        //Initialization vector: IV
        if ($this->cbc == 1) {
            if($this->iv === null){
                $cipher[0][0] = time();
                $cipher[0][1] = (double)microtime() * 1000000;
            }else{
                $cipher[0][0] = $this->iv[0];
                $cipher[0][1] = $this->iv[1];
            }
        }

        $a = 1;
        for ($i = 0; $i < count($text); $i += 2) {
            if ($this->cbc == 1) {
                //$text mit letztem Geheimtext XOR Verknuepfen
                //$text is XORed with the previous ciphertext
                $text[$i] ^= $cipher[$a - 1][0];
                $text[$i + 1] ^= $cipher[$a - 1][1];
            }

            $cipher[] = $this->block_encrypt($text[$i], $text[$i + 1]);
            $a++;
        }

        $output = "";
        for ($i = ($this->iv === null?0:1); $i < count($cipher); $i++) {
            $output .= $this->_long2str($cipher[$i][0]);
            $output .= $this->_long2str($cipher[$i][1]);
        }

        return base64_encode($output);
    }


    //Entschluesseln
    function decrypt($text)
    {
        $plain = array();
        $cipher = $this->_str2long(base64_decode($text));
        if($this->iv !== null) {
            $cipher = array_merge($this->iv,$cipher);
        }

        if ($this->cbc == 1)
            $i = 2; //Message start at second block
        else
            $i = 0; //Message start at first block

        for ($i; $i < count($cipher); $i += 2) {
            $return = $this->block_decrypt($cipher[$i], $cipher[$i + 1]);

            //Xor Verknuepfung von $return und Geheimtext aus von den letzten beiden Bloecken
            //XORed $return with the previous ciphertext
            if ($this->cbc == 1)
                $plain[] = array($return[0] ^ $cipher[$i - 2], $return[1] ^ $cipher[$i - 1]);
            else          //EBC Mode
                $plain[] = $return;
        }
        $output = "";
        for ($i = 0; $i < count($plain); $i++) {
            $output .= $this->_long2str($plain[$i][0]);
            $output .= $this->_long2str($plain[$i][1]);
        }

        return $output;
    }

    //Bereitet den Key zum ver/entschluesseln vor
    function key_setup($key)
    {
        if (is_array($key))
            $this->key = $key;
        else if (isset($key) && !empty($key))
            $this->key = $this->_str2long(str_pad($key, 16, $key));
        else
            $this->key = array(0, 0, 0, 0);
    }


    //Performs a benchmark
    function benchmark($length = 1000)
    {
        //1000 Byte String
        $string = str_pad("", $length, "text");


        //Key-Setup
        $start1 = time() + (double)microtime();
        $xtea = new Xtea();
        $xtea->key_setup('key');
        $end1 = time() + (double)microtime();

        //Encryption
        $start2 = time() + (double)microtime();
        $xtea->Encrypt($string);
        $end2 = time() + (double)microtime();


        echo "Encrypting " . $length . " bytes: " . round($end2 - $start2, 2) . " seconds (" . round($length / ($end2 - $start2), 2) . " bytes/second)<br>";


    }

    //verify the correct implementation of the blowfish algorithm
    function check_implementation()
    {

        $xtea = new Xtea();
        $xtea->key_setup('key');
        $vectors = array(
            array(array(0x00000000, 0x00000000, 0x00000000, 0x00000000), array(0x41414141, 0x41414141), array(0xed23375a, 0x821a8c2d)),
            array(array(0x00010203, 0x04050607, 0x08090a0b, 0x0c0d0e0f), array(0x41424344, 0x45464748), array(0x497df3d0, 0x72612cb5)),

        );

        //Correct implementation?
        //Test vectors, see http://www.schneier.com/code/vectors.txt
        foreach ($vectors AS $vector) {
            $key = $vector[0];
            $plain = $vector[1];
            $cipher = $vector[2];

            $xtea->key_setup($key);
            $return = $xtea->block_encrypt($vector[1][0], $vector[1][1]);

            if ((int)$return[0] != (int)$cipher[0] || (int)$return[1] != (int)$cipher[1])
                return false;
        }
        return true;
    }


    /***********************************
     * Some internal functions
     ***********************************/
    function block_encrypt($y, $z)
    {
        $sum = 0;
        $delta = 0x9e3779b9;


        /* start cycle */
        for ($i = 0; $i < 32; $i++) {
            $y = $this->_add($y,
                $this->_add($z << 4 ^ $this->_rshift($z, 5), $z) ^
                $this->_add($sum, $this->key[$sum & 3]));

            $sum = $this->_add($sum, $delta);

            $z = $this->_add($z,
                $this->_add($y << 4 ^ $this->_rshift($y, 5), $y) ^
                $this->_add($sum, $this->key[$this->_rshift($sum, 11) & 3]));

        }

        /* end cycle */
        $v[0] = $y;
        $v[1] = $z;

        return array($y, $z);

    }

    function block_decrypt($y, $z)
    {
        $delta = 0x9e3779b9;
        $sum = 0xC6EF3720;
        $n = 32;

        /* start cycle */
        for ($i = 0; $i < 32; $i++) {
            $z = $this->_add($z,
                -($this->_add($y << 4 ^ $this->_rshift($y, 5), $y) ^
                    $this->_add($sum, $this->key[$this->_rshift($sum, 11) & 3])));
            $sum = $this->_add($sum, -$delta);
            $y = $this->_add($y,
                -($this->_add($z << 4 ^ $this->_rshift($z, 5), $z) ^
                    $this->_add($sum, $this->key[$sum & 3])));

        }
        /* end cycle */

        return array($y, $z);
    }


    function _rshift($integer, $n)
    {
        // convert to 32 bits
        if (0xffffffff < $integer || -0xffffffff > $integer) {
            $integer = fmod($integer, 0xffffffff + 1);
        }

        // convert to unsigned integer
        if (0x7fffffff < $integer) {
            $integer -= 0xffffffff + 1.0;
        } elseif (-0x80000000 > $integer) {
            $integer += 0xffffffff + 1.0;
        }

        // do right shift
        if (0 > $integer) {
            $integer &= 0x7fffffff;                     // remove sign bit before shift
            $integer >>= $n;                            // right shift
            $integer |= 1 << (31 - $n);                 // set shifted sign bit
        } else {
            $integer >>= $n;                            // use normal right shift
        }

        return $integer;
    }


    function _add($i1, $i2)
    {
        $result = 0.0;

        foreach (func_get_args() as $value) {
            // remove sign if necessary
            if (0.0 > $value) {
                $value -= 1.0 + 0xffffffff;
            }

            $result += $value;
        }

        // convert to 32 bits
        if (0xffffffff < $result || -0xffffffff > $result) {
            $result = fmod($result, 0xffffffff + 1);
        }

        // convert to signed integer
        if (0x7fffffff < $result) {
            $result -= 0xffffffff + 1.0;
        } elseif (-0x80000000 > $result) {
            $result += 0xffffffff + 1.0;
        }

        return $result;
    }


    //Einen Text in Longzahlen umwandeln
    //Covert a string into longinteger
    function _str2long($data)
    {
        $n = strlen($data);
        $tmp = unpack('N*', $data);
        $data_long = array();
        $j = 0;

        foreach ($tmp as $value) $data_long[$j++] = $value;
        return $data_long;
    }

    //Longzahlen in Text umwandeln
    //Convert a longinteger into a string
    function _long2str($l)
    {
        return pack('N', $l);
    }

}
```

```PHP
//使用mcrypt加密：
$data = '1234567890123456';
$key = md5('1230456789', true);
$iv = '\0\0\0\0';
 
$encrypted = mcrypt_encrypt(MCRYPT_XTEA, $key, $data, MCRYPT_MODE_CBC, $iv);
$edata = base64_encode($encrypted);
return $edata;

//使用Xtea加密：
$data = '1234567890123456';
$key = md5('1230456789', true);
$iv = '\0\0\0\0';
 
$x = new Xtea();
$x->key_setup($key);
$x->iv_setup($iv);
$edata = $x->encrypt($data);
return $edata;

//使用Xtea解密：
$key = md5('1230456789', true);
$iv = '\0\0\0\0';
 
$x = new Xtea();
$x->key_setup($key);
$x->iv_setup($iv);
$data = $x->decrypt($edata);
return $data;
```

## 算法名称、IV、BlockSize、key参照表

摘抄自：https://github.com/mfpierre/go-mcrypt

|Cipher Name|Block Mode|Block Size|IV Size|Default Key Size|All Key Size(s)|
|--- |--- |--- |--- |--- |--- |
|CAST-128|CBC|8|8|16|16|
|CAST-128|ECB|8|8|16|16|
|CAST-128|OFB|8|8|16|16|
|CAST-128|NOFB|8|8|16|16|
|CAST-128|CFB|8|8|16|16|
|CAST-128|NCFB|8|8|16|16|
|CAST-128|CTR|8|8|16|16|
|GOST|CBC|8|8|32|32|
|GOST|ECB|8|8|32|32|
|GOST|OFB|8|8|32|32|
|GOST|NOFB|8|8|32|32|
|GOST|CFB|8|8|32|32|
|GOST|NCFB|8|8|32|32|
|GOST|CTR|8|8|32|32|
|Rijndael-128|CBC|16|16|32|16 24 32|
|Rijndael-128|ECB|16|16|32|16 24 32|
|Rijndael-128|OFB|16|16|32|16 24 32|
|Rijndael-128|NOFB|16|16|32|16 24 32|
|Rijndael-128|CFB|16|16|32|16 24 32|
|Rijndael-128|NCFB|16|16|32|16 24 32|
|Rijndael-128|CTR|16|16|32|16 24 32|
|Twofish|CBC|16|16|32|16 24 32|
|Twofish|ECB|16|16|32|16 24 32|
|Twofish|OFB|16|16|32|16 24 32|
|Twofish|NOFB|16|16|32|16 24 32|
|Twofish|CFB|16|16|32|16 24 32|
|Twofish|NCFB|16|16|32|16 24 32|
|Twofish|CTR|16|16|32|16 24 32|
|RC4|STREAM|1|0|256||
|CAST-256|CBC|16|16|32|16 24 32|
|CAST-256|ECB|16|16|32|16 24 32|
|CAST-256|OFB|16|16|32|16 24 32|
|CAST-256|NOFB|16|16|32|16 24 32|
|CAST-256|CFB|16|16|32|16 24 32|
|CAST-256|NCFB|16|16|32|16 24 32|
|CAST-256|CTR|16|16|32|16 24 32|
|LOKI97|CBC|16|16|32|16 24 32|
|LOKI97|ECB|16|16|32|16 24 32|
|LOKI97|OFB|16|16|32|16 24 32|
|LOKI97|NOFB|16|16|32|16 24 32|
|LOKI97|CFB|16|16|32|16 24 32|
|LOKI97|NCFB|16|16|32|16 24 32|
|LOKI97|CTR|16|16|32|16 24 32|
|Rijndael-192|CBC|24|24|32|16 24 32|
|Rijndael-192|ECB|24|24|32|16 24 32|
|Rijndael-192|OFB|24|24|32|16 24 32|
|Rijndael-192|NOFB|24|24|32|16 24 32|
|Rijndael-192|CFB|24|24|32|16 24 32|
|Rijndael-192|NCFB|24|24|32|16 24 32|
|Rijndael-192|CTR|24|24|32|16 24 32|
|Safer+|CBC|16|16|32|16 24 32|
|Safer+|ECB|16|16|32|16 24 32|
|Safer+|OFB|16|16|32|16 24 32|
|Safer+|NOFB|16|16|32|16 24 32|
|Safer+|CFB|16|16|32|16 24 32|
|Safer+|NCFB|16|16|32|16 24 32|
|Safer+|CTR|16|16|32|16 24 32|
|WAKE|STREAM|1|0|32|32|
|Blowfish|CBC|8|8|56||
|Blowfish|ECB|8|8|56||
|Blowfish|OFB|8|8|56||
|Blowfish|NOFB|8|8|56||
|Blowfish|CFB|8|8|56||
|Blowfish|NCFB|8|8|56||
|Blowfish|CTR|8|8|56||
|DES|CBC|8|8|8|8|
|DES|ECB|8|8|8|8|
|DES|OFB|8|8|8|8|
|DES|NOFB|8|8|8|8|
|DES|CFB|8|8|8|8|
|DES|NCFB|8|8|8|8|
|DES|CTR|8|8|8|8|
|Rijndael-256|CBC|32|32|32|16 24 32|
|Rijndael-256|ECB|32|32|32|16 24 32|
|Rijndael-256|OFB|32|32|32|16 24 32|
|Rijndael-256|NOFB|32|32|32|16 24 32|
|Rijndael-256|CFB|32|32|32|16 24 32|
|Rijndael-256|NCFB|32|32|32|16 24 32|
|Rijndael-256|CTR|32|32|32|16 24 32|
|Serpent|CBC|16|16|32|16 24 32|
|Serpent|ECB|16|16|32|16 24 32|
|Serpent|OFB|16|16|32|16 24 32|
|Serpent|NOFB|16|16|32|16 24 32|
|Serpent|CFB|16|16|32|16 24 32|
|Serpent|NCFB|16|16|32|16 24 32|
|Serpent|CTR|16|16|32|16 24 32|
|xTEA|CBC|8|8|16|16|
|xTEA|ECB|8|8|16|16|
|xTEA|OFB|8|8|16|16|
|xTEA|NOFB|8|8|16|16|
|xTEA|CFB|8|8|16|16|
|xTEA|NCFB|8|8|16|16|
|xTEA|CTR|8|8|16|16|
|Blowfish|CBC|8|8|56||
|Blowfish|ECB|8|8|56||
|Blowfish|OFB|8|8|56||
|Blowfish|NOFB|8|8|56||
|Blowfish|CFB|8|8|56||
|Blowfish|NCFB|8|8|56||
|Blowfish|CTR|8|8|56||
|enigma|STREAM|1|0|13||
|RC2|CBC|8|8|128||
|RC2|ECB|8|8|128||
|RC2|OFB|8|8|128||
|RC2|NOFB|8|8|128||
|RC2|CFB|8|8|128||
|RC2|NCFB|8|8|128||
|RC2|CTR|8|8|128||
|3DES|CBC|8|8|24|24|
|3DES|ECB|8|8|24|24|
|3DES|OFB|8|8|24|24|
|3DES|NOFB|8|8|24|24|
|3DES|CFB|8|8|24|24|
|3DES|NCFB|8|8|24|24|
|3DES|CTR|8|8|24|24|