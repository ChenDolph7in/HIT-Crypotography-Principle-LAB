package utilTest;

import org.junit.jupiter.api.Test;
import util.PhoneFormatCheckUtils;

import static org.junit.jupiter.api.Assertions.assertFalse;

public class PhoneFormatCheckUtilsTest {
    @Test
    public void isPhoneLegalTest(){
        // 错误输入-空
        assertFalse(PhoneFormatCheckUtils.isPhoneLegal(""));
        // 错误输入-空格
        assertFalse(PhoneFormatCheckUtils.isPhoneLegal(" "));
        // 错误输入-长度小于8
        assertFalse(PhoneFormatCheckUtils.isPhoneLegal("1111111"));
        // 错误输入-长度大于11
        assertFalse(PhoneFormatCheckUtils.isPhoneLegal("11111111111"));
        // 错误输入-7开头香港手机号
        assertFalse(PhoneFormatCheckUtils.isPhoneLegal("71111111"));
        // 错误输入-开头3个数字不符合大陆运营商规范
        assertFalse(PhoneFormatCheckUtils.isPhoneLegal("12011231144"));
    }
}
