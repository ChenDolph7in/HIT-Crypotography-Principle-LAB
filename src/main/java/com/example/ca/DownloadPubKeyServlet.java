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

@WebServlet(name = "DownLoadPubKeyServlet", value = "/DownLoadPubKeyServlet")
public class DownloadPubKeyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public DownloadPubKeyServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //实现文件下载 设置响应头
        String userid = (String) request.getSession().getAttribute("userid");
        request.getSession().getAttribute("userid");
        //String fileName = this.getServletContext().getRealPath("")+"../"+"upload/"+"zly.jpg";
        //String fileName = "D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\keys\\user_public_key.pem";
        String fileName = "D:\\java\\sourse\\CA\\ca\\keys\\user_public_key.pem";
        response.setHeader("Content-Disposition", "attachment;filename=" + "user_public_key.pem");
        System.out.print("fileName" + fileName);
        //先使用文件输入流 将文件读到内存中 再使用输出流 将文件输出给用户
        File file = new File(fileName);
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
