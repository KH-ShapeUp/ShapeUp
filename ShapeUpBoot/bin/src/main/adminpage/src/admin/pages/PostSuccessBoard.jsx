import React, { useMemo } from "react";
import BoardManager from "../components/BoardManager";
import "../styles/PostNotice.css";

const PostSuccessBoard = () => {
  const initialPosts = useMemo(
    () => [
      {
        id: 1,
        date: "2025.10.28",
        author: "member01",
        category: "다이어트",
        title: "3개월 -12kg 후기",
        content: "3개월간 식단과 운동으로 12kg 감량했습니다.",
        attachments: ["before-after.jpg"],
      },
      {
        id: 2,
        date: "2025.10.29",
        author: "member04",
        category: "근력",
        title: "데드리프트 150kg 성공",
        content: "목표했던 150kg 달성!",
        attachments: ["deadlift.mp4"],
      },
      {
        id: 3,
        date: "2025.11.02",
        author: "member09",
        category: "생활",
        title: "꾸준한 스트레칭 효과",
        content: "하루 10분 스트레칭의 효과를 공유합니다.",
        attachments: [],
      },
      {
        id: 4,
        date: "2025.11.05",
        author: "member02",
        category: "다이어트",
        title: "식단 꿀팁 공유",
        content: "탄단지를 맞추는 방법을 정리했습니다.",
        attachments: ["meal-plan.pdf"],
      },
    ],
    []
  );

  return (
    <BoardManager
      boardTitle="성공 후기"
      initialPosts={initialPosts}
      categories={["다이어트", "근력", "생활"]}
      chartData={[3, 4, 2, 5, 4]}
      chartDatasetLabel="후기 등록 수"
      detailMode="readonly"
    />
  );
};

export default PostSuccessBoard;
