<?php
/**
 * Created by PhpStorm.
 * User: Aris
 * Date: 2018/12/23
 * Time: 下午8:54
 */

namespace App\Common;

class RSA{

    private $private_key = '-----BEGIN RSA PRIVATE KEY-----
///
-----END RSA PRIVATE KEY-----';

    public $public_key = '-----BEGIN PUBLIC KEY-----
///
-----END PUBLIC KEY-----';

    /**
     * 公钥加密
     * @param $data
     * @return string
     */
	public function public_encrypt($data){
		$public_key = $this->public_key;
		$pu_key = openssl_pkey_get_public($public_key);
		
		openssl_public_encrypt($data, $encrypted, $pu_key);//公钥加密
		$encrypted = (base64_encode($encrypted));
		return $encrypted;
	}

    /**
     * 私钥解密
     * @param $after_encode_data
     * @return mixed
     */
    public function private_decrypt($after_encode_data){
        $private_key = $this->private_key;
        openssl_private_decrypt(
            base64_decode($after_encode_data),
            $decode_result,
            $private_key
        );
        return $decode_result;
    }
}