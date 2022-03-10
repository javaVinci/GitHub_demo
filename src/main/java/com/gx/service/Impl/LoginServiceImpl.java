package com.gx.service.Impl;

import com.gx.dao.LoginDao;
import com.gx.po.UserPo;
import com.gx.service.LoginService;
import com.gx.vo.LayuiTableData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("loginService")
@Transactional
public class LoginServiceImpl implements LoginService {

    @Autowired
    @Qualifier("loginDao")
    private LoginDao loginDao;


    @Override
    public LayuiTableData<UserPo> selectUser(Integer page, Integer limit) {
        List<UserPo> data = this.loginDao.selectUser(page, limit);
        int count = this.selectUserCount();
        return new LayuiTableData<>(count, data);
    }

    @Override
    public int selectUserCount() {
        return this.loginDao.selectUserCount();
    }

    @Override
    public boolean addUser(UserPo userPo) {
        boolean isOk = this.loginDao.addUser(userPo) > 0;
        if (!isOk) throw new RuntimeException("新增用户异常");
        return true;
    }

    @Override
    public boolean updateUser(UserPo userPo) {
        boolean isOk = this.loginDao.updateUser(userPo) > 0;
        if (!isOk) throw new RuntimeException("修改用户异常");
        return true;
    }

    @Override
    public boolean deleteUser(Integer id) {
        boolean isOk = this.loginDao.deleteUser(id) > 0;
        if (!isOk) throw new RuntimeException("删除用户异常");
        return true;
    }

    @Override
    public UserPo selectAllById(Integer id) {
        return this.loginDao.selectAllById(id);
    }
}
