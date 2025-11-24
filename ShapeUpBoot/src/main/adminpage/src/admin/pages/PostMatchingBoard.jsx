import React, { useEffect, useMemo, useState } from "react";
import BoardManager from "../components/BoardManager";

const PostMatchingBoard = () => {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const categories = useMemo(() => ["모집중", "마감", "완료"], []);

  useEffect(() => {
    const fetchList = async () => {
      setLoading(true);
      try {
        const res = await fetch("http://localhost:8080/matching/list?page=1", { credentials: "include" });
        if (!res.ok) throw new Error("failed");
        const data = await res.json();
        const list = Array.isArray(data.mList) ? data.mList : [];
        const mapped = list.map((item) => ({
          id: item.matchingNo,
          date: item.createdAt ? String(item.createdAt).slice(0, 10).replace(/-/g, ".") : "",
          author: item.userNickName || `USER_${item.userNo}`,
          category: item.activityName || "매칭",
          status: item.matchingType || (item.deleteYn === "Y" ? "삭제" : "모집중"),
          title: item.matchingTitle,
          content: item.matchingContent,
          location: item.matchingLocation,
          matchingDate: item.matchingDate,
          matchingTime: item.matchingTime,
          level: item.matchingLevel,
          partnerType: item.partnerType,
          matchingUserCount: item.matchingUserCount,
          matchingType: item.matchingType,
          price: item.matchingPrice,
        }));
        setPosts(mapped);
      } catch (e) {
        console.error("매칭 목록 불러오기 실패", e);
        setPosts([]);
      } finally {
        setLoading(false);
      }
    };
    fetchList();
  }, []);

  return (
    <BoardManager
      boardTitle="매칭 게시판"
      initialPosts={posts}
      categories={categories}
      chartData={[5, 7, 6, 8, 9]}
      chartDatasetLabel="매칭 모집 등록 수"
      detailMode="readonly"
      storageKey={null}
      showStatusColumn
      showMoveButton={false}
      loading={loading}
    />
  );
};

export default PostMatchingBoard;
