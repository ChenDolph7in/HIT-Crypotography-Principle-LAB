<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.UUID" %>
<%@page import="util.DigestUtil" %>
<%@page import="util.IdCardVerification" %>
<%@page import="util.PhoneFormatCheckUtils" %>
<%@page import="util.Rsa" %>
<%@ page import="java.net.URLDecoder" %>

<html>
<head>
    <title>CA-注册结果</title>
    <link rel="icon" href="images/favicon.ico">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/animate.css">
    <link rel="stylesheet" href="css/magnific-popup.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <!-- Main css -->
    <link rel="stylesheet" href="css/style.css">
    <style type="text/css">
        body{
            background-image: url(images/background.jpg);
            background-size:cover;
        }
    </style>
</head>
<body data-spy="scroll" data-target=".navbar-collapse" data-offset="50">
<!-- PRE LOADER -->
<div class="preloader">
    <div class="spinner">
        <span class="spinner-rotate"></span>
    </div>
</div>

<!-- NAVIGATION SECTION -->
<div class="navbar custom-navbar navbar-fixed-top" role="navigation">
    <div class="container">

        <div class="navbar-header">
            <button class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="icon icon-bar"></span>
                <span class="icon icon-bar"></span>
                <span class="icon icon-bar"></span>
            </button>
            <!-- lOGO TEXT HERE -->
            <a href="registerResult.jsp" class="navbar-brand" style="color:white">CA-注册结果</a>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-right">
                <li><a class="smoothScroll" href="index.html" style="color:white">首页</a></li>
                <li><a class="smoothScroll" href="login.html" style="color:white">登录</a></li>
                <li><a class="smoothScroll" href="register.html" style="color:white">注册</a></li>
            </ul>
        </div>

    </div>
</div>

<section id="home">
    <div class="container">
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");  //驱动程序名
                String url = "jdbc:mysql://localhost:3306/ca"; //数据库名
                String basename = "root";  //数据库用户名
                String db_password = "7757123";  //数据库用户密码
                Connection conn = DriverManager.getConnection(url, basename, db_password);  //连接状态
                if (conn != null) {
                    Statement stmt = null;
                    ResultSet rs = null;
                    Rsa rsa = new Rsa();
                    /*System.out.println(request.getParameter("userid"));
                    System.out.println(request.getParameter("username"));
                    System.out.println(request.getParameter("password"));
                    System.out.println(request.getParameter("phonenum"));*/
                    String userid = rsa.decryptByPrivateKey(request.getParameter("userid"));
                    //String username = rsa.decryptByPrivateKey(request.getParameter("username"));
                    String username = URLDecoder.decode(rsa.decryptByPrivateKey(request.getParameter("username")),"UTF-8");
                    String password = rsa.decryptByPrivateKey(request.getParameter("password"));
                    String phonenum = rsa.decryptByPrivateKey(request.getParameter("phonenum"));

                    String sql = "SELECT * FROM userinfo WHERE userid = \"" + userid + "\"";    //查询语句
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery(sql);
                    if (rs.next()) {%>
        <tr>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">注册失败，该身份证已被注册</h2>
            </div>
        </tr>
        <%
        } else if (!IdCardVerification.IDCardValidate(userid).equals("该身份证有效！")) {
        %>
        <tr>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">身份证无效</h2>
            </div>
        </tr>
        <%
        } else if (!PhoneFormatCheckUtils.isPhoneLegal(phonenum)) {
        %>
        <tr>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">手机号无效</h2>
            </div>
        </tr>
        <%
        } else {
            String salt = UUID.randomUUID().toString();
            password = DigestUtil.getSHA1((password + salt).getBytes());
            sql = "INSERT INTO userinfo(userid,username,password,phonenum,salt) values(\"" +
                    userid + "\",\"" + username + "\",\"" + password + "\",\"" + phonenum + "\",\"" + salt + "\");";
            stmt = conn.createStatement();
            stmt.execute(sql);
        %>
        <tr>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">注册成功</h2>
                <form action="login.html" method="post">
                    <div align="center"><button type="submit">登录</button></div>
                </form>
            </div>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">连接失败</h2>
            </div>
        </tr>
        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <tr>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">数据库连接异常</h2>
            </div>
        </tr>
        <%
            }
        %>
    </div>
</section>
<!-- SCRIPTS -->
<script src="js/jquery.js"></script>
<script src="js/jquery.magnific-popup.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/magnific-popup-options.js"></script>
<script src="js/wow.min.js"></script>
<script src="js/custom.js"></script>
<script src="js/smoothscroll.js"></script>
<script>
    function rsa_decode($after_encode_data)
    {
        // 读取私钥文件
        var private_key = file_get_contents('rsa_private_key.pem');
        openssl_private_decrypt(
            base64_decode($after_encode_data),
            $decode_result,
            $private_key
        );
        return $decode_result;
    }
</script>
</body>
</html>