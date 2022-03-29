<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.UUID" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="util.*" %>

<html>
<head>
    <title>CA-撤销证书</title>
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

<%
    String userid = (String) session.getAttribute("userid");
    System.out.println("cert_withdraw_result:userid=" + userid);
    session.setAttribute("userid", userid);
%>

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
            <a href="cert_withdraw.jsp" class="navbar-brand" style="color:white">CA-撤销证书</a>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-right">
                <li><a class="smoothScroll" href="menu.jsp" style="color:white">菜单</a></li>
                <li><a class="smoothScroll" href="cert_generate.jsp" style="color:white">生成证书</a></li>
                <li><a class="smoothScroll" href="crl_download.jsp" style="color:white">下载CRL</a></li>
                <li><a class="smoothScroll" href="cert_download.jsp" style="color:white">下载证书</a></li>
                <li><a class="smoothScroll" href="cert_search.jsp" style="color:white">查询证书</a></li>
                <li><a class="smoothScroll" href="cert_withdraw.jsp" style="color:white">撤销证书</a></li>
                <li><a class="smoothScroll" href="key_generate.jsp" style="color:white">生成密钥</a></li>
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
                    //System.out.println("request.getParameter(userid):"+request.getParameter("userid"));
                    //System.out.println("request.getParameter(password):"+request.getParameter("password"));
                    String password = rsa.decryptByPrivateKey(request.getParameter("password"));
                    //System.out.println("get_userid:"+userid);
                    System.out.println("get_password:" + password);
                    String sql = "SELECT * FROM userinfo WHERE userid = \"" + userid + "\"";    //查询语句
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery(sql);
                    if (rs.next()) {
                        String salt = rs.getString("salt");
                        String check_pwd = DigestUtil.getSHA1((password + salt).getBytes());
                        if (check_pwd.equals((rs.getString("password")))) {
                            OpenSSLUtil openssl = new OpenSSLUtil();
                            openssl.revokeCert(userid);
        %>
        <tr>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">撤回证书成功</h2>
                <form action="menu.jsp" method="post">
                    <div align="center">
                        <button type="submit">确认</button>
                    </div>
                </form>
            </div>

        </tr>
        <%
        } else {
        %>
        <tr>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">登陆失败</h2>
                <h3 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">请从点击确认返回</h3>
                <form action="menu.jsp" method="post">
                    <div align="center">
                        <button type="submit">确认</button>
                    </div>
                </form>
            </div>
        </tr>
        <%
                }
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
    function rsa_decode($after_encode_data) {
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