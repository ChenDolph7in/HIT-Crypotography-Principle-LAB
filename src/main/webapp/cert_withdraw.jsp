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
    System.out.println("cert_withdraw:userid="+userid);
    session.setAttribute("userid",userid);
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
        <tr>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">是否确认撤回证书？</h2>
                <h3 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">撤回后不能取消，只能再次申请</h3>
                <h3 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">请输入密码确认</h3>
            </div>
            <form action="cert_withdraw_result.jsp" method="post">
                <div align="center"><input type="password" name="password" placeholder="用户密码"
                                           id="password"
                                           required="required"></div>
                <br/>
                <div align="center">
                    <input type="submit" value="确认" onclick="return rsa()"><br/>
                </div>
            </form>
        </tr>
    </div>
</section>
<!-- SCRIPTS -->
<script src="js/jquery.js"></script>
<script src="js/jquery.magnific-popup.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/magnific-popup-options.js"></script>
<script src="js/wow.min.js"></script>
<script src="js/custom.js"></script>
<script src="js/md5.js"></script>
<script src="js/smoothscroll.js"></script>
<script src="js/RSA.js"></script>
<script type="text/javascript">
    function rsa() {
        var passwordNode=document.getElementById("password");
        if(passwordNode.value.length<6){
            alert("密码长度过短！");
            return false;
        }else if(passwordNode.value.length>18){
            alert("密码长度过长！");
            return false;
        }
        var secret = rsa_encode(passwordNode.value);
        passwordNode.value=secret;
        //alert(passwordNode.value);
    }
</script>
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