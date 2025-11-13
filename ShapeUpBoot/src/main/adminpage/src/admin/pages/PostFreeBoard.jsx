import React, { useMemo } from "react";
import BoardManager from "../components/BoardManager";
import "../styles/PostNotice.css";

const PostFreeBoard = () => {
  const initialPosts = useMemo(
    () => [
      {
        id: 1,
        date: "2025.11.12",
        author: "user01",
        category: "정보",
        title: "PT 효과 공유",
        content: "지난 6개월간의 PT 후기를 공유합니다.",
        attachments: ["pt_plan.pdf", "progress.png"],
      },
      {
        id: 2,
        date: "2025.11.12",
        author: "user05",
        category: "잡담",
        title: "오늘 러닝 10km 인증",
        content: "러닝 10km 기록 인증합니다!",
        attachments: ["running.jpg"],
      },
      {
        id: 3,
        date: "2025.11.13",
        author: "user08",
        category: "정보",
        title: "보충제 추천 모음",
        content: "제가 먹어본 보충제 리스트 공유합니다.",
        attachments: ["supplement-list.xlsx"],
      },
      {
        id: 4,
        date: "2025.11.13",
        author: "user12",
        category: "이벤트",
        title: "헬린이 모임 안내",
        content: "주말에 헬린이 모임 진행합니다.",
        attachments: [],
      },
      {
        id: 5,
        date: "2025.11.14",
        author: "user15",
        category: "잡담",
        title: "오운완 합시다",
        content: "오늘 운동 완료! 다들 화이팅",
        attachments: ["gym-selfie.png"],
      },
    ],
    []
  );

  return (
    <BoardManager
      boardTitle="자유 게시판"
      initialPosts={initialPosts}
      categories={["정보", "잡담", "이벤트"]}
      chartData={[8, 11, 9, 7, 10]}
      chartDatasetLabel="게시글 등록 수"
      detailMode="readonly"
    />
  );
};

export default PostFreeBoard;
