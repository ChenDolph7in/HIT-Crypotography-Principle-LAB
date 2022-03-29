<?php
/**
 * Created by PhpStorm.
 * User: aris
 * Date: 2018/11/25
 * Time: 下午4:45
 */


/**
 * RSA私钥解密，需在php.ini开启php_openssl.dll扩展
 * @param String : after_encode_data 前端传来，经 RSA 加密后的数据
 * @return 返回解密后的数据
 */
function rsa_decode($after_encode_data)
{
    // 读取私钥文件
    $private_key = file_get_contents('rsa_private_key.pem');
    openssl_private_decrypt(
        base64_decode($after_encode_data),
        $decode_result,
        $private_key
    );
    return $decode_result;
}


$username_default = $_POST['username'];
$pswd_default = $_POST['pswd'];

$username_decode = rsa_decode($username_default);
$pswd_decode = rsa_decode($pswd_default);

$arr = array( 'username_decode'=>$username_decode, 'pswd_decode'=>$pswd_decode, 'username_default'=>$username_default, 'pswd_default'=>$pswd_default);

echo json_encode($arr,JSON_UNESCAPED_UNICODE);