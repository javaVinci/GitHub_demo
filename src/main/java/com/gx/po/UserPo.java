package com.gx.po;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Data
public class UserPo {
    //    id int NOT NULL
    private Integer id;
    //    user_name varchar(20) NULL用户名
    private String userName;
    //    tel varchar(11) NULL手机号码
    private String tel;
    //    birthday datetime NULL生日
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
//    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date birthday;
    //    size varchar(50) NULL地址
    private String size;
    //    portrait varchar(200) NULL头像
    private String portrait;
//    status tinyint NULL0:显示，1：删除
    private Byte status;
}
