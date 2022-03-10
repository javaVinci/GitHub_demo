package com.gx.dao;

import com.gx.po.UserPo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("loginDao")
public interface LoginDao {

    //查询所有用户表信息
    List<UserPo> selectUser(@Param("page") Integer page, @Param("limit") Integer limit);

    //查询所有用户表信息条数
    int selectUserCount();

    //添加用户
    int addUser(UserPo userPo);

    //修改用户
    int updateUser(UserPo userPo);

    //删除用户信息
    int deleteUser(Integer id);

    //通过id查询用户信息
    UserPo selectAllById(Integer id);
}
