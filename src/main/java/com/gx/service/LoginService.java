package com.gx.service;

import com.gx.po.UserPo;
import com.gx.vo.LayuiTableData;

public interface LoginService {

    //查询所有用户表信息
    LayuiTableData<UserPo> selectUser(Integer page, Integer limit);

    //查询所有用户表信息条数
    int selectUserCount();

    //添加用户
    boolean addUser(UserPo userPo);

    //修改用户
    boolean updateUser(UserPo userPo);

    //删除用户信息
    boolean deleteUser(Integer id);

    //通过id查询用户信息
    UserPo selectAllById(Integer id);
}
