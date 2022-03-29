package com.example.ca;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "DownLoadServlet", value = "/DownLoadServlet")
public class DownloadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public DownloadServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //实现文件下载 设置响应头
        String userid = (String) request.getSession().getAttribute("userid");
        request.getSession().getAttribute("userid");
        String filepath = null;
        String filename = null;
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
                    filepath = rs.getString("filepath");
                    filename = rs.getString("filename");
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        if (filepath == null || filename == null) {
            return;
        }
        //String fileName = this.getServletContext().getRealPath("") + "ca\\certs\\" + filename;
        //String fileName = filepath;
        response.setHeader("Content-Disposition", "attachment;filename=" + userid+"_cert.crt");
        filepath.replaceAll("//","\\\\");
        System.out.println("filePath : " + filepath);
        //先使用文件输入流 将文件读到内存中 再使用输出流 将文件输出给用户
        File file = new File(filepath);
        FileInputStream fileIn = new FileInputStream(file);
        //准备一个缓冲区
        byte[] b = new byte[(int) file.length()];
        //将文件读入缓冲区中
        fileIn.read(b);
        //获得响应的输出流
        ServletOutputStream sout = response.getOutputStream();
        //调用response.getOutputStream()方法返回 ServeltOutputStream 对象来向客户端写入文件内容。
        sout.write(b);
        sout.close();
    }
}
