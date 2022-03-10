package com.gx.vo;

import lombok.Data;

import java.io.Serializable;

@Data
public class JsonMsg implements Serializable {
    /**
     *
     */
    private static final long serialVersionUID = 5863100019332084445L;

    private Boolean state;//状态
    private int code;
    private String msg;
    private Object data;

    public JsonMsg() {
    }

    public JsonMsg(String msg) {
        this.msg = msg;
    }

    public JsonMsg(Boolean state, String msg) {
        this(msg);
        this.state = state;
    }

    public JsonMsg(Boolean state, String msg, Object data) {
        this(state, msg);
        this.data = data;
    }
}
