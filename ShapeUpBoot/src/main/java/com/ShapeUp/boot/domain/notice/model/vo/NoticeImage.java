package com.ShapeUp.boot.domain.notice.model.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class NoticeImage {
    private Integer imgNo;
    private String imgPath;
    private String imgRename;
    private String imgOriginalName;
    private String imgMainYn;
    private Integer noticeNo;
}
