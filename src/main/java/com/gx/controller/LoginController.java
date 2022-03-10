package com.gx.controller;

import com.gx.po.UserPo;
import com.gx.service.LoginService;
import com.gx.util.Tools;
import com.gx.vo.JsonMsg;
import com.gx.vo.LayuiTableData;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
@RequestMapping("/login")
public class LoginController {

    private static final String UPLOAD_PATH = "G:\\桌面\\测试 (2)\\portrait\\";//员工头像上传目录

    @Autowired
    @Qualifier("loginService")
    private LoginService loginService;

    @RequestMapping("")
    public String login() {
        return "/login";
    }

    /**
     * @param page  每页条数
     * @param limit 定义每页
     * @return
     */
    @RequestMapping(value = "/selectUserPage", produces = "application/json;charset=utf-8")
    @ResponseBody
    public LayuiTableData<UserPo> selectUserPage(Integer page, Integer limit) {

        return this.loginService.selectUser(page, limit);
    }

    /**
     * 根据图片名返回图片流
     */
    @RequestMapping("/getPortraitImage")
    public void getPortraitImage(String imgName, HttpServletResponse response) throws IOException {
        // 获取参数
        if (Tools.isNotNull(imgName)) {
            //图片名不未空
            String imgPath = UPLOAD_PATH + imgName;
            File fileImg = new File(imgPath);
            if (fileImg.exists()) {
                //指定返的类型
                response.setContentType(Tools.getImageContentType(imgName));

                InputStream in = null;
                OutputStream out = null;
                try {
                    in = new FileInputStream(fileImg);
                    out = response.getOutputStream();
                    //复制
                    // byte[] buff=new byte[1024*1024*10];//10M
                    // int count=0;
                    // while ((count=in.read(buff,0,buff.length))!=-1){
                    //     out.write(buff,0,count);
                    // }
                    //commons-io
                    IOUtils.copy(in, out);
                    out.flush();
                } finally {
                    if (in != null) in.close();
                    if (out != null) out.close();
                }

            }
        }
    }

    //添加用户
    @RequestMapping(value = "/addUser", produces = "application/json;charset=utf-8")
    @ResponseBody
    public JsonMsg addUser(UserPo userPo, MultipartFile portraitFile) throws IOException {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmssSSS_");

        //判断文件存放目录是否存在
        File uploadDir = new File(UPLOAD_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        //处理上传 文件
        if (portraitFile != null && portraitFile.getBytes().length > 0) {
            //拼接文件名  item.getName()--》文件名
            String fileName = dateFormat.format(new Date()) + System.nanoTime() + Tools.getFileExt(portraitFile.getOriginalFilename());
            //存放路径
            String filePath = UPLOAD_PATH + fileName;
            File saveFile = new File(filePath);
            System.err.println(filePath);
            //保存文件到硬盘
            portraitFile.transferTo(saveFile);
            //把文件名保存到需要新增的对象中
            userPo.setPortrait(fileName);
        }
        //判断是否为空
        if (!Tools.isNotNull(userPo.getUserName())) return new JsonMsg("用户名不能为空");
        if (!Tools.isNotNull(userPo.getTel())) return new JsonMsg("电话不能为空");
        if (!Tools.isNotNull(userPo.getSize())) return new JsonMsg("地址不能为空");
        if (userPo.getBirthday() == null) return new JsonMsg("生日不能为空");

        try {
            boolean isOk = this.loginService.addUser(userPo);
            if (isOk) {
                return new JsonMsg(true, "新增成功");
            } else {
                return new JsonMsg("新增失败");
            }
        } catch (RuntimeException e) {
            return new JsonMsg(e.getMessage());
        }
    }

    //修改用户
    @RequestMapping(value = "/updateUser", produces = "application/json;charset=utf-8")
    @ResponseBody
    public JsonMsg updateUser(UserPo userPo, MultipartFile portraitFile) throws IOException {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmssSSS_");
        //判断文件存放目录是否存在
        File uploadDir = new File(UPLOAD_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        //处理上传 文件
        if (portraitFile != null && portraitFile.getBytes().length > 0) {
            //拼接文件名  item.getName()--》文件名
            String fileName = dateFormat.format(new Date()) + System.nanoTime() + Tools.getFileExt(portraitFile.getOriginalFilename());
            //存放路径
            String filePath = UPLOAD_PATH + fileName;
            File saveFile = new File(filePath);
            System.err.println(filePath);
            //保存文件到硬盘
            portraitFile.transferTo(saveFile);
            //把文件名保存到需要新增的对象中
            userPo.setPortrait(fileName);
        }

        //判断是否为空
        if (!Tools.isNotNull(userPo.getUserName())) return new JsonMsg("用户名不能为空");
        if (!Tools.isNotNull(userPo.getTel())) return new JsonMsg("电话不能为空");
        if (!Tools.isNotNull(userPo.getSize())) return new JsonMsg("地址不能为空");
        if (userPo.getBirthday() == null) return new JsonMsg("生日不能为空");

        String oldPortraitImageName = null;
        //是否有新的图片上传，有就查询旧的图片名称
        if (Tools.isNotNull(userPo.getPortrait())) {
            UserPo oldUser = this.loginService.selectAllById(userPo.getId());
            oldPortraitImageName = oldUser.getPortrait();
        }
        try {
            boolean isOk=this.loginService.updateUser(userPo);
            if (isOk){
                if (Tools.isNotNull(oldPortraitImageName)){
                    File oldFile = new File(UPLOAD_PATH,oldPortraitImageName);
                    if (oldFile.exists()){
                        oldFile.delete();
                    }
                }
                return new JsonMsg(true,"修改成功");
            }else {
                return new JsonMsg("修改用户失败");
            }
        }catch (RuntimeException e){
            return new JsonMsg(e.getMessage());
        }
    }

    //删除用户
    @RequestMapping(value = "/deleteUser",produces = "application/json;charset=utf-8")
    @ResponseBody
    public JsonMsg deleteUser(Integer id){
        try {
            boolean isOk = this.loginService.deleteUser(id);
            if (isOk){
                return new JsonMsg(true,"删除成功");
            }else {
                return new JsonMsg("删除用户失败");
            }
        }catch (RuntimeException e){
            return new JsonMsg(e.getMessage());
        }

    }

}
