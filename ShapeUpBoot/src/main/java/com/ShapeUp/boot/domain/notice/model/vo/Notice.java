 package com.ShapeUp.boot.domain.notice.model.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class Notice {

    private int noticeNo;
    private String noticeTitle;
    private String noticeContent;
    private String category;
    private Integer userNo;
    private String userName;
    private Timestamp createAt;
    private Timestamp updateAt;
    private String evStartAt;
    private String evEndDate;
    private Integer viewCount;
    private List<NoticeImage> images;
}
