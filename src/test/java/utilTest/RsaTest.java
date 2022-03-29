package utilTest;

import org.junit.jupiter.api.Test;
import util.Rsa;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class RsaTest {

    @Test
    public void RsaTest(){
        Rsa rsa = new Rsa();
        // 测试私钥加密
        String str = "testtesttesttest";
        String crypt = rsa.encryptByPrivateKey(str);
        String result = rsa.decryptByPublicKey(crypt);
        assertEquals(result,str);

        // 测试公钥加密
        crypt = rsa.encryptByPublicKey(str);
        result = rsa.decryptByPrivateKey(crypt);
        assertEquals(result,str);

        // 测试签名
        String str1 = rsa.signByPrivateKey(str);
        assertTrue(rsa.verifyByPublicKey(str1, str));
    }
}
