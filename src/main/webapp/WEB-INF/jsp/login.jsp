<%--
  Created by IntelliJ IDEA.
  User: KongBai
  Date: 2022/2/26
  Time: 8:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="page"/>
<!DOCTYPE html>
<html>
<head>
    <title>主页</title>
    <link rel="stylesheet" href="${ctx}/static/layui/css/layui.css">
</head>
<body>
<div style="width: 300px;margin-left: 84px;margin-top: 20px;">
    <button type="button" class="layui-btn" id="add">新增</button>
    <button type="button" class="layui-btn layui-btn-warm" id="update">修改</button>
    <button type="button" class="layui-btn layui-btn-danger" id="delete">删除</button>
</div>
<div style="width: 950px">
    <table id="demo" lay-filter="test"></table>
</div>

<div style="display: none" id="upPortraitDiv">
    <div>
        <input type="file" hidden name="portrait" id="upPortrait"><%--头像上传文本框--%>
    </div>
</div>
<form class="layui-form" id="formUser" lay-filter="formUser" style="display: none;margin: 20px;"
      autocomplete="off">
    <input id="bool" value="0" style="display: none">
    <div class="layui-col-md3">
        <img src="${ctx}/static/image/uploadImg.png" id="userPicture" alt="头像"
             style="max-height: 340px; width:221px">
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">用户名</label>
        <div class="layui-input-block">
            <input type="text" name="userName" lay-verify="required" placeholder="请输入用户名" autocomplete="off" class="layui-input"
                   style="width: 200px">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">手机号码</label>
        <div class="layui-input-block">
            <input type="text" lay-verify="required|phone" name="tel" placeholder="请输入手机号码" autocomplete="off" class="layui-input"
                   style="width: 200px">
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">日期时间选择器</label>
        <div class="layui-input-inline">
            <input type="text" name="birthday" class="layui-input" id="birthday" placeholder="请输入生日">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">地址</label>
        <div class="layui-input-block">
            <input type="text" name="size" lay-verify="required" placeholder="请输入" autocomplete="off" class="layui-input"
                   style="width: 200px">
        </div>
    </div>
    <div>
        <button type="submit" class="layui-btn" lay-submit lay-filter="formUserSubmit">提交</button>
        <button type="reset" id="reset" class="layui-btn layui-btn-warm">重置</button>
    </div>
</form>
<script src="${ctx}/static/layui/layui.js"></script>
<script>
    layui.use(function () {
        var $ = layui.$;
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        table.render({
            elem: '#demo'
            , id: "demo"
            , height: 312
            , url: '${ctx}/login/selectUserPage' //数据接口
            , page: true //开启分页
            , cols: [[ //表头
                {type: "radio"}
                , {field: 'userName', title: '用户名'}
                , {field: 'tel', title: '电话'}
                , {
                    field: 'birthday', title: '生日', width: 160,
                    templet: function (rowData) {
                        var date = new Date(rowData.birthday)
                        //2021-03-02 20:33:0
                        return date.getFullYear() + '-' +
                            (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1)) + "-" +
                            (date.getDate() < 10 ? '0' + (date.getDate()) : (date.getDate())) + " " +
                            date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();

                    }
                }
                , {field: 'size', title: '地址'}
                , {
                    field: 'portrait', title: '头像', event: "portrait",
                    templet: function (rowData) {
                        return '<img src="${ctx}/login/getPortraitImage?imgName=' + rowData.portrait + '" class="portraitImg">';
                    }
                }
            ]],
            limit: 10,//每页条数
            limits: [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]//定义每页条数选择下拉框
        });

        //图片上传部分
        //双击图片弹出文件选择框
        $("#userPicture").dblclick(function () {
            $("#upPortrait").click();
        });
        //图片文件 正则表达式过滤image/jpeg,image/png,image/jpg,image/gif,image/bmp
        var regexImageFilter = /^(?:image\/bmp|image\/gif|image\/jpg|image\/jpeg|image\/png)$/i;
        var imgReader = new FileReader();

        //文件读取器读取到文件后的回调事件
        imgReader.onload = function (event) {
            //显示图片 base64编码的图片
            $("#userPicture").attr("src", event.target.result);
        }

        $("#upPortraitDiv").on('change', 'input[type="file"]', function () {
            //获取出文件选择器中的第一个文件
            var file = $("#upPortrait").get(0).files[0];
            //判断文件选择类型
            if (regexImageFilter.test(file.type)) {
                //读取文件转换成URL把图片转为Base64编码
                imgReader.readAsDataURL(file);
            } else {
                layer.alert("请选择图片");
            }
        });

        //打开新增弹窗
        $("#add").click(function () {
            $("#reset").click();
            //清空文件选择框
            document.getElementById("upPortrait").outerHTML = document.getElementById("upPortrait").outerHTML;
            $("#userPicture").prop("src", '${ctx}/static/image/uploadImg.png');
            $("#bool").val(0);
            //日期时间选择器
            laydate.render({
                elem: '#birthday'
                , type: 'datetime'
            });
            layer.open({
                type: 1,//0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）
                skin: 'layui-layer-molv',
                area: ['700px', '650px'],
                title: '新增用户',
                content: $("#formUser"),
                cancel: function () {
                    layer.closeAll();
                }
            });
        })

        //打开修改弹窗
        $("#update").click(function () {
            $("#reset").click();
            //清空文件选择框
            document.getElementById("upPortrait").outerHTML = document.getElementById("upPortrait").outerHTML;
            $("#bool").val(1);
            var checkStatus = table.checkStatus('demo'); //idTest 即为基础参数 id 对应的值
            // console.log(checkStatus.data) //获取选中行的数据
            // console.log(checkStatus.data.length) //获取选中行数量，可作为是否有选中行的条件
            // console.log(checkStatus.isAll) //表格是否全选
            if (checkStatus.data.length < 1) return layer.msg("请选择要修改的数据")
            //回填用户头像
            if (checkStatus.data[0].portrait != undefined && checkStatus.data[0].portrait != null && checkStatus.data[0].portrait != "") {
                $("#userPicture").prop("src", '${ctx}/login/getPortraitImage?imgName=' + checkStatus.data[0].portrait)
            }else {
                $("#userPicture").prop("src", '${ctx}/static/image/uploadImg.png');
            }
            //回填时间
            var date = new Date(checkStatus.data[0].birthday)
            if (date != null) {
                //2021-03-02 20:33:0
                date = date.getFullYear() + '-' +
                    (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1)) + "-" +
                    (date.getDate() < 10 ? '0' + (date.getDate()) : (date.getDate())) + " " +
                    date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
            }
            laydate.render({
                elem: '#birthday'
                , type: 'datetime'
                , value: date
            });
            //回填数据
            form.val("formUser", { //formTest 即 class="layui-form" 所在元素属性 lay-filter="" 对应的值
                "userName": checkStatus.data[0].userName // "name": "value"
                ,"tel": checkStatus.data[0].tel
                ,"size": checkStatus.data[0].size
            });
            //打开修改弹窗
            layer.open({
                type: 1,//0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）
                skin: 'layui-layer-molv',
                area: ['700px', '650px'],
                title: '修改用户',
                content: $("#formUser"),
                cancel: function () {
                    layer.closeAll();
                }
            });
        })

        //提交表单
        form.on('submit(formUserSubmit)', function (data) {
            // console.log(data.elem) //被执行事件的元素DOM对象，一般为button对象
            // console.log(data.form) //被执行提交的form对象，一般在存在form标签时才会返回
            // console.log(data.field) //当前容器的全部表单字段，名值对形式：{name: value}
            var bool =$("#bool").val();
            var url = '';
            if (bool == 0) {
                url = '${ctx}/login/addUser'
            } else if (bool == 1) {
                url = '${ctx}/login/updateUser'
                var checkStatus = table.checkStatus('demo'); //idTest 即为基础参数 id 对应的值
                data.field.id = checkStatus.data[0].id
            }
            // data.field.birthday = new Date(data.field.birthday).getTime();
             var ajaxData = new FormData();
            // //把layui form返回json格式数据转为 FormData
            // /*
            //  fromData.field
            //  {
            //     a:"",
            //     b:"",
            //     c:"",
            //  }
            //  */
            // // x是指被循环对象的属性名称
            // //js的数组是特殊对象，x就是 索引 0,1,2,3.....
            for (var x in data.field) {
                ajaxData.append(x, data.field[x]);
            }
            var file = $("#upPortrait").get(0).files[0];
            ajaxData.append('portraitFile', file);
            //console.log(data.field);
            // //异步请求
            // //提交表单
            var layerIndex = layer.load();
            $.ajax({
                type: "POST",//文件上传 只能是post
                url: url,
                data: ajaxData,
                cache: false,
                processData: false,//禁止jquery对上传的数据进行处理
                contentType: false,
                dataType: 'json',
                success: function (jsonMsg) {
                    layer.close(layerIndex);
                    if (jsonMsg.state) {
                        layer.closeAll();//关闭弹窗
                        table.reloadData('demo', {});//表格的重载
                        layer.msg(jsonMsg.msg, {icon: 6});
                    } else {
                        layer.msg(jsonMsg.msg, {icon: 5});
                    }
                }
            });
            return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
        });

        //删除用户
        $("#delete").click(function () {
            var checkStatus = table.checkStatus('demo'); //idTest 即为基础参数 id 对应的值
            // console.log(checkStatus.data) //获取选中行的数据
            // console.log(checkStatus.data.length) //获取选中行数量，可作为是否有选中行的条件
            // console.log(checkStatus.isAll) //表格是否全选
            //判断是否选中要删除的数据
            if (checkStatus.data.length < 1) return layer.msg("请选择要删除的数据")
            var id = checkStatus.data[0].id
            //询问框
            layer.confirm('确定要删除吗？', {icon: 3, title:'提示'}, function(index){
                //do something
                //异步提交
                var layerIndex = layer.load();
                $.post('${ctx}/login/deleteUser', {id: id}, function (jsonMsg) {
                    if (jsonMsg.state) {
                        layer.close(layerIndex)
                        layer.closeAll();//关闭弹窗
                        table.reloadData('demo');//表格的重载
                        layer.msg(jsonMsg.msg, {icon: 6});
                    } else {
                        layer.msg(jsonMsg.msg, {icon: 5});
                    }
                }, 'json')
                layer.close(index);
            });


        })
    })
</script>
</body>
</html>
