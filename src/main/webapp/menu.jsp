<%@page contentType="text/html" pageEncoding="UTF-8" %>

<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>CA-菜单</title>
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
    System.out.println("menu:userid=" + userid);
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
            <a href="menu.jsp" class="navbar-brand" style="color:white">CA-菜单</a>
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
<!-- HOME SECTION -->
<section id="home">

    <div class="container">
        <div class="row">
            <%--<div class="col-md-8 col-sm-8">--%>
            <div align="center">
                <h1 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white"> 欢迎您！</h1>
                <h2 class="wow fadeInUp" data-wow-delay="1.0s" style="color:white"> 请选择功能：</h2>
            </div>
            <div align="center">
                <input type="button" style="width:150px;height:60px;margin:15px;" value="生成证书"
                       onclick="window.location='cert_generate.jsp'"/>
                <input type="button" style="width:150px;height:60px;margin:15px;" value="下载CRL"
                       onclick="window.location='crl_download.jsp'"/>
                <input type="button" style="width:150px;height:60px;margin:15px;" value="下载证书"
                       onclick="window.location='cert_download.jsp'"/>
                <br/>
                <input type="button" style="width:150px;height:60px;margin:15px;" value="查询证书"
                       onclick="window.location='cert_search.jsp'"/>
                <input type="button" style="width:150px;height:60px;margin:15px;" value="撤销证书"
                       onclick="window.location='cert_withdraw.jsp'"/>
                <input type="button" style="width:150px;height:60px;margin:15px;" value="生成密钥"
                       onclick="window.location='key_generate.jsp'"/>
            </div>
        </div>
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
        var useridNode = document.getElementById("userid");
        var passwordNode = document.getElementById("password");
        if (passwordNode.value.length < 6) {
            alert("密码长度过短！");
            return false;
        } else if (passwordNode.value.length > 18) {
            alert("密码长度过长！");
            return false;
        }

        var secret = rsa_encode(useridNode.value);
        useridNode.value = secret;
        //alert(useridNode.value);
        secret = rsa_encode(passwordNode.value);
        passwordNode.value = secret;
        //alert(passwordNode.value);
    }
</script>
<script type="text/javascript">
    function toMd5() {
        var passwordNode = document.getElementById("password");
        //alert(passwordNode.value);
        var hash = hex_md5(passwordNode.value);
        passwordNode.value = hash;
        //alert(passwordNode.value);
    }
</script>
</body>

</html>