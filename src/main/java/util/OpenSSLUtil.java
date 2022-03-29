package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.*;

import static java.lang.Thread.sleep;

public class OpenSSLUtil {

    public static void main(String[] args) {
        OpenSSLUtil test = new OpenSSLUtil();
        //test.generateRSAkeys();
        //System.out.println(test.verify("D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\certs\\rsaCerReq.crt"));
        //test.generateCertFromCsr("231182200104227536","test4.csr","D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\csrs\\test4.csr");
        test.revokeCert("231182200104227534");
    }

    private void execCommand(String[] arstringCommand) {
        Process process = null;

        for (int i = 0; i < arstringCommand.length; i++) {

            System.out.print(arstringCommand[i] + " ");
        }

        try {
            process = Runtime.getRuntime().exec(arstringCommand);

            /*BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));

            String line = null;
            StringBuffer b = new StringBuffer();
            while ((line = bufferedReader.readLine()) != null) {
                b.append(line + "\n");
            }
            System.out.println(b.toString());*/
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    private void execCommand(String arstringCommand) {
        try {
            Runtime.getRuntime().exec(arstringCommand);

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void generateCertFromCsr(String userid, String filename, String filepath) {
        String[] firstname = filename.split(".csr");
        String[] rootpath = filepath.split("csrs");
        String outpath = rootpath[0] + "certs//" + firstname[0] + ".crt";
        String outname = firstname[0] + ".crt";

        System.out.println("outpath:"+outpath);
        System.out.println("outname:"+outname);

        //根据请求生成证书
        //String[] cmds = {"cmd","/C","openssl ca -in "+filepath+" -out "+outpath+" -cert D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\ca.crt -keyfile D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\rsa_private_key.pem -config D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\openssl.cnf"+" < "+"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\yy.txt"};
        String[] cmds = {"cmd","/C","openssl ca -in "+filepath+" -out "+outpath+" -cert D:\\java\\sourse\\CA\\ca\\ca.crt -keyfile D:\\java\\sourse\\CA\\ca\\rsa_private_key.pem -config D:\\java\\sourse\\CA\\ca\\openssl.cnf"+" < "+"D:\\java\\sourse\\CA\\ca\\yy.txt"};
        try {
            Process process = Runtime.getRuntime().exec(cmds);

            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));

            String line = null;
            StringBuffer b = new StringBuffer();
            while ((line = bufferedReader.readLine()) != null) {
                b.append(line + "\n");
            }
            System.out.println(b.toString());
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        try {
            sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");  //驱动程序名
            String url = "jdbc:mysql://localhost:3306/ca"; //数据库名
            String basename = "root";  //数据库用户名
            String db_password = "7757123";  //数据库用户密码
            Connection conn = DriverManager.getConnection(url, basename, db_password);  //连接状态
            Statement stmt = null;
            if (conn != null) {
                String sql = "INSERT INTO certs(userid,filename,filepath) values(\"" +
                        userid + "\",\"" + outname + "\",\"" + outpath + "\");";
                stmt = conn.createStatement();
                stmt.executeUpdate(sql);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public void revokeCert(String userid) {
        String filepath = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");  //驱动程序名
            String url = "jdbc:mysql://localhost:3306/ca"; //数据库名
            String basename = "root";  //数据库用户名
            String db_password = "7757123";  //数据库用户密码
            Connection conn = DriverManager.getConnection(url, basename, db_password);  //连接状态
            Statement stmt = null;
            ResultSet rs = null;
            if (conn != null) {
                String sql = "SELECT * FROM certs where userid = \"" + userid + "\";";
                stmt = conn.createStatement();
                rs = stmt.executeQuery(sql);
                rs.next();
                filepath = rs.getString("filepath");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }


        if (filepath == null) {
            return;
        }
        System.out.println("filepath = " + filepath);
        filepath = filepath.replaceAll("//","\\\\");
        System.out.println("filepath(//changed) = " + filepath);

        //撤销证书
        String[] arstringCommand = new String[]{

                "cmd ", "/c",
                "start", // cmd Shell命令

                "openssl",
                "ca",
                "-cert",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\ca.crt",
                "D:\\java\\sourse\\CA\\ca\\ca.crt",
                "-keyfile",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\rsa_private_key.pem",
                "D:\\java\\sourse\\CA\\ca\\rsa_private_key.pem",
                "-revoke",
                filepath,
                "-config",
                "D:\\java\\sourse\\CA\\ca\\openssl.cnf"
        };
        execCommand(arstringCommand);

        try {
            sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        //更新CRL
        arstringCommand = new String[]{

                "cmd ", "/c",
                "start", // cmd Shell命令

                "openssl",
                "ca",
                "-gencrl",
                "-out",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\crl.crl",
                "D:\\java\\sourse\\CA\\ca\\crl.crl",
                "-config",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\openssl.cnf"
                "D:\\java\\sourse\\CA\\ca\\openssl.cnf"
        };
        execCommand(arstringCommand);

        //从certs表中删除
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");  //驱动程序名
            String url = "jdbc:mysql://localhost:3306/ca"; //数据库名
            String basename = "root";  //数据库用户名
            String db_password = "7757123";  //数据库用户密码
            Connection conn = DriverManager.getConnection(url, basename, db_password);  //连接状态
            Statement stmt = null;
            if (conn != null) {
                String sql = "DELETE FROM certs where userid = \"" + userid + "\";";
                stmt = conn.createStatement();
                stmt.executeUpdate(sql);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        //从csrs表中删除
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");  //驱动程序名
            String url = "jdbc:mysql://localhost:3306/ca"; //数据库名
            String basename = "root";  //数据库用户名
            String db_password = "7757123";  //数据库用户密码
            Connection conn = DriverManager.getConnection(url, basename, db_password);  //连接状态
            Statement stmt = null;
            if (conn != null) {
                String sql = "DELETE FROM csrs where userid = \"" + userid + "\";";
                stmt = conn.createStatement();
                stmt.executeUpdate(sql);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean verify(String filepath) {
        String[] arstringCommand = new String[]{

                "cmd ", "/c",
                //"start", // cmd Shell命令

                "openssl",
                "verify",
                "-extended_crl",
                "-crl_check_all",
                "-crl_download",
                "-CRLfile",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\crl.crl",
                "D:\\java\\sourse\\CA\\ca\\crl.crl",
                "-CAfile",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\ca.crt",
                "D:\\java\\sourse\\CA\\ca\\ca.crt",
                filepath
        };

        for (int i = 0; i < arstringCommand.length; i++) {
            System.out.print(arstringCommand[i] + " ");
        }
        System.out.println();

        try {
            Process process = Runtime.getRuntime().exec(arstringCommand);
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line = null;
            StringBuffer b = new StringBuffer();
            while ((line = bufferedReader.readLine()) != null) {
                b.append(line + "\n");
            }
            System.out.println(b.toString());
            if (b.toString().indexOf("OK") != -1) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return false;
    }

    public void generateRSAkeys(){
        // 生成私钥
        String[] arstringCommand = new String[]{

                "cmd ", "/c",
                "start", // cmd Shell命令

                "openssl",
                "genrsa",
                "-out",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\keys\\user_private_key.pem",
                "D:\\java\\sourse\\CA\\ca\\keys\\user_private_key.pem",
                "2048"
        };
        execCommand(arstringCommand);
        // 将私钥格式改为 PCKS8
        arstringCommand = new String[]{

                "cmd ", "/c",
                "start", // cmd Shell命令

                "openssl",
                "pkcs8",
                "-topk8",
                "-inform",
                "PEM",
                "-in",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\keys\\user_private_key.pem",
                "D:\\java\\sourse\\CA\\ca\\keys\\user_private_key.pem",
                "-outform",
                "PEM",
                "–nocrypt"
        };
        execCommand(arstringCommand);
        // 根据私钥生成公钥
        arstringCommand = new String[]{

                "cmd ", "/c",
                "start", // cmd Shell命令

                "openssl",
                "rsa",
                "-in",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\keys\\user_private_key.pem",
                "D:\\java\\sourse\\CA\\ca\\keys\\user_private_key.pem",
                "-pubout",
                "-out",
                //"D:\\java\\sourse\\CA\\src\\main\\webapp\\ca\\keys\\user_public_key.pem"
                "D:\\java\\sourse\\CA\\ca\\keys\\user_public_key.pem"
        };
        execCommand(arstringCommand);
    }
}
