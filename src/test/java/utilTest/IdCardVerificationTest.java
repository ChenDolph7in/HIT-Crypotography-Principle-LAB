package utilTest;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static util.IdCardVerification.IDCardValidate;

public class IdCardVerificationTest {

    @Test
    public void IDCardValidateTest() throws java.text.ParseException{
//        1、正确数据-输入15位身份证号，例如320311770706001
        assertEquals("该身份证有效！",IDCardValidate("320311770706001"));
//        2、正确数据-输入18位身份证号且只有数字，例如130701199310302288
        assertEquals("该身份证有效！",IDCardValidate("130701199310302288"));
//        3、正确数据_输入18位身份证号且最后一位为X，例如52030219891209794X
        assertEquals("该身份证有效！",IDCardValidate("52030219891209794X"));
//        4、错误数据_输入18位身份证号且最后一位为除X外的字母，例如52030219891209794Y
        assertEquals("身份证校验码无效，不是合法的身份证号码",IDCardValidate("52030219891209794Y"));
//        5、错误数据-输入数字少于15位，例如32031177070600
        assertEquals("身份证号码长度应该为15位或18位。",IDCardValidate("32031177070600"));
//        6、错误数据-输入数字多于15位少于18位，例如3203117707060011
        assertEquals("身份证号码长度应该为15位或18位。",IDCardValidate("3203117707060011"));
//        7、错误数据-输入数字少于18位，例如52030219891209794
        assertEquals("身份证号码长度应该为15位或18位。",IDCardValidate("52030219891209794"));
//        8、错误数据-输入数字多于18位，例如5203021989120979412
        assertEquals("身份证号码长度应该为15位或18位。",IDCardValidate("5203021989120979412"));
//        9、错误数据-身份证号中含有字母，例如52030219aaaaddd8912
        assertEquals("身份证号码长度应该为15位或18位。",IDCardValidate("52030219aaaaddd8912"));
//        10、错误数据-输入数据中含有特殊字符，例如520@#￥%&×302198912
        assertEquals("身份证15位号码都应为数字 ; 18位号码除最后一位外，都应为数字。",IDCardValidate("520@#￥%&×302198912"));
//        11、错误数据-输入为空
        assertEquals("身份证号码长度应该为15位或18位。",IDCardValidate(""));
//        12、错误数据-输入为空格
        assertEquals("身份证号码长度应该为15位或18位。",IDCardValidate(" "));
    }
}

