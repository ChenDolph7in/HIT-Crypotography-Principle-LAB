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
    <title>CA-生成证书</title>
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
    System.out.println("cert_generate:userid=" + userid);
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
            <a href="cert_generate.jsp" class="navbar-brand" style="color:white">CA-生成证书</a>
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
        <div class="row">
            <%-- <div class="col-md-8 col-sm-8">--%>
            <div align="center">
                <h1 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">生成证书</h1>
            </div>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");  //驱动程序名
                    String url = "jdbc:mysql://localhost:3306/ca"; //数据库名
                    String basename = "root";  //数据库用户名
                    String db_password = "7757123";  //数据库用户密码
                    Connection conn = DriverManager.getConnection(url, basename, db_password);  //连接状态
                    Statement stmt = null;
                    ResultSet rs = null;
                    if (conn != null) {
                        String sql = "SELECT * FROM certs WHERE userid = \"" + userid + "\"";    //查询语句
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery(sql);
                        if (rs.next()) {
            %>
            <div align="center">
                <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">该账号已经生成证书</h2>
                <h3 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white">请到“证书下载”界面下载证书</h3>
            </div>
            <div align="center">
                <form action="menu.jsp" method="post">
                    <div align="center">
                        <button type="submit">确认</button>
                    </div>
                </form>
            </div>
            <%
            } else {
            %>
            <form action="UploadServlet" enctype="multipart/form-data" method="post">
                <div align="center">
                    <h2 class="wow fadeInUp" data-wow-delay="0.6s" style="color:white"> 请使用OpenSSL生成CSR证书请求文件并上传</h2>
                    <h3 class="wow fadeInUp" data-wow-delay="0.6s"><a
                            href="https://blog.csdn.net/KiTok/article/details/90349671" style="color:white">Windows安装使用OpenSSL参考教程</a></h3>
                    <h3 class="wow fadeInUp" data-wow-delay="0.6s"><a
                            href="https://blog.csdn.net/qq_15259303/article/details/81133735" style="color:white">使用OpenSSL生成RSA公私钥和CSR证书请求文件参考教程</a>
                    </h3>
                    <p style="color:white">注：一个用户只能生成一个证书，请求文件命名格式***.csr(***为任意英文，最好与生成的CSR文件有关)</p>
                </div>
                <div align="center"><input type="file" name="fileName" placeholder="请求csr"
                                           id="fileName"
                                           required="required"></div>
                <br/>
                <div align="center"><input type="submit" value="确认" onclick="return rsa()"><br/></div>
            </form>
            <%
                        }
                    }
                } catch (ClassNotFoundException | SQLException e) {
                    e.printStackTrace();
                }

            %>
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
        var companynameNode = document.getElementById("company_name");
        var locationNode = document.getElementById("location");
        var domainNode = document.getElementById("domain");
        //var domainNode=document.getElementById("password");
        /*if(passwordNode.value.length<6){
            alert("密码长度过短！");
            return false;
        }else if(passwordNode.value.length>18){
            alert("密码长度过长！");
            return false;
        }*/
        //var secret=rsa_encode(usernameNode.value);
        var secret = rsa_encode(encodeURI(companynameNode.value));//防止RSA加解密后出现乱码
        companynameNode.value = secret;
        //alert(companynameNode.value);
        secret = rsa_encode(encodeURI(locationNode.value))
        locationNode.value = secret;
        //alert(locationNode.value);
        secret = rsa_encode(encodeURI(domainNode.value))
        domainNode.value = secret;
        //alert(domainNode.value);

        // $.ajax({
        //     url:'json_test.php',
        //     data:{"username":rsa_encode(username), "pswd":rsa_encode(pswd)},
        //     type:'post',
        //
        //     success: function(data){
        //         alert(data);
        //         window.location.reload()
        //
        //     },
        //     error: function(XMLHttpRequest, textStatus, errorThrown) {
        //         alert(XMLHttpRequest.status);
        //         alert(XMLHttpRequest.readyState);
        //         alert(textStatus);
        //     },
        // });
    }
</script>
<script type="text/javascript">
    function toMd5() {
        var passwordNode = document.getElementById("password");
        alert(passwordNode.value);
        var hash = hex_md5(passwordNode.value);
        passwordNode.value = hash;
        alert(passwordNode.value);
    }
</script>

</body>
</html>