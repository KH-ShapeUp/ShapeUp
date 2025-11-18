import React, { useMemo } from "react";
import BoardManager from "../components/BoardManager";
import "../styles/PostNotice.css";
import { BOARD_STORAGE_KEYS } from "../../common/utils/storageKeys";

const PostNotice = () => {
  const initialPosts = useMemo(
    () => [
      { id: 1, date: "2025.12.12", author: "관리자", category: "공지", title: "서비스 점검 안내" },
      { id: 2, date: "2025.12.13", author: "관리자", category: "업데이트", title: "신규 기능 추가" },
      { id: 3, date: "2025.12.14", author: "운영팀", category: "공지", title: "회원 정책 변경" },
      {
        id: 4,
        author: "마케팅팀",
        category: "이벤트",
        title: "겨울 맞이 이벤트",
        startDate: "2025.12.20",
        endDate: "2026.01.05",
      },
      {
        id: 5,
        author: "운영팀",
        category: "이벤트",
        title: "새해 복권 이벤트",
        startDate: "2026.01.10",
        endDate: "2026.01.31",
      },
    ],
    []
  );

  return (
    <BoardManager
      boardTitle="공지사항"
      initialPosts={initialPosts}
      categories={["공지", "업데이트", "이벤트"]}
      chartLabels={["11월 1주", "11월 2주", "11월 3주", "11월 4주", "12월 1주"]}
      chartData={[5, 9, 3, 7, 6]}
      chartDatasetLabel="공지 등록 수"
      storageKey={BOARD_STORAGE_KEYS.NOTICE}
    />
  );
};

export default PostNotice;
