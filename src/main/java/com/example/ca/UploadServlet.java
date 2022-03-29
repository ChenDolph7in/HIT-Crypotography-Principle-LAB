package com.example.ca;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import util.OpenSSLUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.List;

@WebServlet(name = "UploadServlet", value = "/UploadServlet")
public class UploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UploadServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //获得一个文件上传的工厂类
        DiskFileItemFactory dfif = new DiskFileItemFactory();//DiskFileItemFactory 是创建 FileItem 对象的工厂
        //设置文件上传临时存储的大小8M
        dfif.setSizeThreshold(1024 * 1024 * 8);
        //指定临时文件目录，默认值为当前用户的系统临时文件目录，可通过System.getProperty(“java.io.tmpdir”)打印查看；
        dfif.setRepository(new File("java.io.tmpdir"));
        System.out.println(System.getProperty("java.io.tmpdir"));
        //使用servlet来处理文件上传
        ServletFileUpload upload = new ServletFileUpload(dfif);
        //设置文件上传的大小
        upload.setSizeMax(1024 * 1024 * 50);
        //获得当前服务器的路径
        String uploadPath = "D://java//sourse//CA//ca//csrs";
        //String uploadPath = "D://java//sourse//CA//src//main//webapp//ca//csrs";
        /*this.getServletContext().getRealPath("");
        System.out.println("当前服务器路径---->" + uploadPath);
        uploadPath = uploadPath + "//ca//csrs";*/
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        try {
            List<FileItem> formItem = upload.parseRequest(request);
            if (formItem != null && formItem.size() > 0) {
                //循环遍历要上传的文件
                for (FileItem item : formItem) {
                    if (!item.isFormField()) {
                        //获得要上传的文件的名字
                        String fileName = new File(item.getName()).getName();
                        fileName = new Date().getTime() + (int) (Math.random() * 100) + fileName;

                        //目的文件
                        String filePath = uploadPath + "//" + fileName;
                        File storeFile = new File(filePath);
                        item.write(storeFile);

                        System.out.println(fileName);
                        System.out.println(filePath);
                        //request.setAttribute("fileName", fileName);

                        //将文件名和路径加入数据库
                        String userid = (String) request.getSession().getAttribute("userid");
                        //System.out.println("userid="+userid);
                        request.getSession().setAttribute("userid", userid);
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");  //驱动程序名
                            String url = "jdbc:mysql://localhost:3306/ca"; //数据库名
                            String basename = "root";  //数据库用户名
                            String db_password = "7757123";  //数据库用户密码
                            Connection conn = DriverManager.getConnection(url, basename, db_password);  //连接状态
                            Statement stmt = null;
                            if (conn != null) {
                                String sql = "INSERT INTO csrs(userid,filename,filepath) values(\"" +
                                        userid + "\",\"" + fileName + "\",\"" + filePath + "\");";
                                stmt = conn.createStatement();
                                stmt.executeUpdate(sql);
                            }
                        } catch (ClassNotFoundException | SQLException e) {
                            e.printStackTrace();
                        }
                        //生成证书
                        OpenSSLUtil util = new OpenSSLUtil();
                        util.generateCertFromCsr(userid, fileName, filePath);
                    }
                }
            }
        } catch (FileUploadException e) {
            e.printStackTrace();
            request.setAttribute("message", "文件上传失败:" + e.getMessage());
            request.getRequestDispatcher("error.html").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("cert_generate_result.jsp").forward(request, response);
    }

}

