import React, { useEffect, useMemo, useRef, useState } from "react";
import { FaEye, FaEyeSlash } from "react-icons/fa";
import Chart from "chart.js/auto";
import "../styles/MembersUser.css";
import CustomSelect from "../../common/components/CustomSelect";
const mapUserToMember = (user) => ({
  id: user.userNo,
  name: user.userName ?? "",
  age: user.userAge ?? 0,
  nickname: user.userNickname ?? "",
  joinedAt: user.createdAt?.slice(0, 10) ?? "",
  category: user.userType === "TRAINER" ? "트레이너" : user.userType === "ADMIN" ? "어드민" : "유저",
  status: user.status ?? "정상",
  gender: user.userSerialNo?.slice(-1) % 2 === 0 ? "여" : "남",
  username: user.userId ?? "",
  password: user.userPw ?? "",
  email: user.userEmail ?? "",
  phone: user.userPhone ?? "",
  rrn: user.userSerialNo ?? "",
});

const searchFieldOptions = ["전체", "아이디", "비밀번호", "이름", "나이", "닉네임"];
const pageSizeOptions = ["5", "10", "30", "50"];
const genderOptions = [
  { label: "남", value: "남" },
  { label: "여", value: "여" },
];
const categoryOptions = [
  { label: "유저", value: "유저" },
  { label: "트레이너", value: "트레이너" },
  { label: "어드민", value: "어드민" },
];
const statusOptions = [
  { label: "정상", value: "정상" },
  { label: "정지", value: "정지" },
  { label: "탈퇴", value: "탈퇴" },
];

const MembersUser = () => {
  const [members, setMembers] = useState([]);
  const [selectedId, setSelectedId] = useState(null);
  const [showPassword, setShowPassword] = useState(false);
  const [sort, setSort] = useState({ key: "id", dir: "asc" });
  const [searchField, setSearchField] = useState("전체");
  const [searchText, setSearchText] = useState("");
  const [pageSize, setPageSize] = useState(10);
  const [page, setPage] = useState(1);
  const [pageInput, setPageInput] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const chartRef = useRef(null);

  useEffect(() => {
    let ignore = false;
    const loadMembers = async () => {
      try {
        setLoading(true);
        const response = await fetch("/api/admin/users");
        if (!response.ok) throw new Error("회원 목록을 불러오지 못했습니다.");
        const data = await response.json();
        if (ignore) return;
        const mapped = Array.isArray(data) ? data.map(mapUserToMember) : [];
        setMembers(mapped);
        setSelectedId(mapped[0]?.id ?? null);
        setError(null);
      } catch (err) {
        console.error(err);
        if (!ignore) setError("회원 정보를 불러오는 중 오류가 발생했습니다.");
      } finally {
        if (!ignore) setLoading(false);
      }
    };
    loadMembers();
    return () => {
      ignore = true;
    };
  }, []);

  const filteredMembers = useMemo(() => {
    const keyword = searchText.trim().toLowerCase();
    if (!keyword) return members;
    const contains = (value) => String(value ?? "").toLowerCase().includes(keyword);

    return members.filter((member) => {
      switch (searchField) {
        case "아이디": return contains(member.username);
        case "비밀번호": return contains(member.password);
        case "이름": return contains(member.name);
        case "나이": return contains(member.age);
        case "닉네임": return contains(member.nickname);
        default:
          return (
            contains(member.username) ||
            contains(member.password) ||
            contains(member.name) ||
            contains(member.age) ||
            contains(member.nickname)
          );
      }
    });
  }, [members, searchField, searchText]);

  const sorted = useMemo(() => {
    const arr = [...filteredMembers];
    const collator = new Intl.Collator("ko");
    const getVal = (m) => {
      switch (sort.key) {
        case "id": return m.id;
        case "name": return m.name ?? "";
        case "age": return m.age ?? 0;
        case "nickname": return m.nickname ?? "";
        case "joinedAt": return m.joinedAt ?? "";
        case "category": return m.category ?? "";
        case "status": return m.status ?? "";
        default: return "";
      }
    };
    arr.sort((a, b) => {
      const va = getVal(a);
      const vb = getVal(b);
      let cmp = 0;
      if (typeof va === "number" && typeof vb === "number") cmp = va - vb;
      else if (sort.key === "joinedAt") cmp = new Date(va).getTime() - new Date(vb).getTime();
      else cmp = collator.compare(String(va), String(vb));
      return sort.dir === "asc" ? cmp : -cmp;
    });
    return arr;
  }, [filteredMembers, sort]);

  const totalMembers = sorted.length;
  const totalPages = Math.max(1, Math.ceil(totalMembers / pageSize));
  const currentPage = Math.min(page, totalPages);
  const pageStart = (currentPage - 1) * pageSize;
  const paginated = sorted.slice(pageStart, pageStart + pageSize);

  useEffect(() => {
    setPage(1);
    setPageInput("");
  }, [searchField, searchText, pageSize]);

  useEffect(() => {
    setPage((prev) => Math.min(prev, totalPages));
  }, [totalPages]);

  useEffect(() => {
    if (!chartRef.current) return;
    const ctx = chartRef.current.getContext("2d");
    const chartInstance = new Chart(ctx, {
      type: "line",
      data: {
        labels: ["6월", "7월", "8월", "9월", "10월", "11월"],
        datasets: [
          {
            label: "가입자 수",
            data: [24, 32, 28, 41, 37, 45],
            borderColor: "#4c8bf5",
            backgroundColor: "rgba(76, 139, 245, 0.15)",
            tension: 0.35,
            fill: true,
          },
          {
            label: "탈퇴자 수",
            data: [5, 7, 6, 4, 8, 5],
            borderColor: "#ff6b6b",
            backgroundColor: "rgba(255, 107, 107, 0.15)",
            tension: 0.35,
            fill: true,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: "bottom" } },
        scales: { y: { beginAtZero: true, ticks: { stepSize: 5 } } },
      },
    });
    return () => chartInstance.destroy();
  }, []);

  const selected = useMemo(() => sorted.find((m) => m.id === selectedId) || null, [sorted, selectedId]);

  useEffect(() => {
    if (selectedId == null) return;
    if (!members.some((member) => member.id === selectedId)) {
      setSelectedId(members[0]?.id ?? null);
    }
  }, [members, selectedId]);

  const updateMembers = (updater) => {
    setMembers((prev) => (typeof updater === "function" ? updater(prev) : updater));
  };

  const handleSelect = (id) => setSelectedId(id);
  const updateMemberField = (name, value) => {
    if (!selected) return;
    updateMembers((prev) => prev.map((m) => (m.id === selected.id ? { ...m, [name]: value } : m)));
  };
  const handleChange = (e) => {
    const { name, value } = e.target;
    updateMemberField(name, value);
  };
  const handleUpdate = () => {
    if (!selected) return;
    alert("저장되었습니다.");
  };

  const toggleSort = (key) => {
    setSort((prev) => (prev.key === key ? { key, dir: prev.dir === "asc" ? "desc" : "asc" } : { key, dir: "asc" }));
  };
  const sortMark = (key) => (sort.key === key ? (sort.dir === "asc" ? " ▲" : " ▼") : "");

  if (loading) {
    return <div className="members-container">회원 정보를 불러오는 중...</div>;
  }

  if (error) {
    return <div className="members-container error-state">{error}</div>;
  }

  return (
    <div className="members-container">
      <div className="members-list">
        <div className="list-header">
          <span>회원 목록 <em className="count-label">(총 회원수 : {totalMembers.toLocaleString()}명)</em></span>
          <div className="members-search">
            <CustomSelect
              value={searchField}
              options={searchFieldOptions}
              onChange={setSearchField}
              size="sm"
            />
            <input type="text" placeholder="검색어를 입력하세요" value={searchText} onChange={(e) => setSearchText(e.target.value)} />
            <CustomSelect
              className="page-size-select"
              value={String(pageSize)}
              options={pageSizeOptions.map((size) => ({ label: `${size}개`, value: size }))}
              onChange={(val) => setPageSize(Number(val))}
              size="sm"/*  */
            />
          </div>
        </div>

        <table className="members-table">
          <thead>
            <tr>
              <th onClick={() => toggleSort("id")} style={{ cursor: "pointer" }}>번호{sortMark("id")}</th>
              <th onClick={() => toggleSort("name")} style={{ cursor: "pointer" }}>이름{sortMark("name")}</th>
              <th onClick={() => toggleSort("age")} style={{ cursor: "pointer" }}>나이{sortMark("age")}</th>
              <th onClick={() => toggleSort("nickname")} style={{ cursor: "pointer" }}>닉네임{sortMark("nickname")}</th>
              <th onClick={() => toggleSort("joinedAt")} style={{ cursor: "pointer" }}>가입일{sortMark("joinedAt")}</th>
              <th onClick={() => toggleSort("category")} style={{ cursor: "pointer" }}>분류{sortMark("category")}</th>
              <th onClick={() => toggleSort("status")} style={{ cursor: "pointer" }}>상태{sortMark("status")}</th>
            </tr>
          </thead>
          <tbody>
            {paginated.map((m, idx) => (
              <tr key={m.id} onClick={() => handleSelect(m.id)} className={selectedId === m.id ? "selected" : ""}>
                <td>{pageStart + idx + 1}</td>
                <td>{m.name}</td>
                <td>{m.age}</td>
                <td>{m.nickname}</td>
                <td>{m.joinedAt}</td>
                <td>{m.category}</td>
                <td>{m.status}</td>
              </tr>
            ))}
          </tbody>
        </table>

        <div className="pagination-controls">
          <button type="button" onClick={() => setPage((prev) => Math.max(1, prev - 1))} disabled={currentPage === 1}>&lt;</button>
          <span className="pagination-status">{currentPage}/{totalPages}</span>
          <input
            type="number"
            min="1"
            max={totalPages}
            className="pagination-input"
            placeholder="페이지 입력"
            value={pageInput}
            onChange={(e) => setPageInput(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                const target = Number(e.currentTarget.value);
                if (!Number.isNaN(target) && target >= 1 && target <= totalPages) {
                  setPage(target);
                  setPageInput("");
                }
              }
            }}
          />
          <button type="button" onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))} disabled={currentPage === totalPages}>&gt;</button>
        </div>
      </div>

      <div className="members-detail">
        <div className="detail-header">회원 상태 수정</div>
        {selected ? (
          <>
            <div className="detail-field">
              <label>이름</label>
              <input name="name" value={selected.name} onChange={handleChange} />
            </div>

            <div className="detail-field">
              <label>닉네임</label>
              <input name="nickname" value={selected.nickname} onChange={handleChange} />
            </div>

            <div className="detail-field">
              <label>성별</label>
              <CustomSelect
                value={selected.gender}
                options={genderOptions}
                onChange={(val) => updateMemberField("gender", val)}
              />
            </div>

            <div className="detail-field">
              <label>아이디</label>
              <input name="username" value={selected.username} onChange={handleChange} />
            </div>

            <div className="detail-field">
              <label>비밀번호</label>
              <div className="password-input">
                <input
                  type={showPassword ? "text" : "password"}
                  name="password"
                  value={selected.password}
                  onChange={handleChange}
                />
                <button
                  type="button"
                  className="eye-btn"
                  onClick={() => setShowPassword((v) => !v)}
                  aria-label="비밀번호 보기"
                >
                  {showPassword ? <FaEyeSlash /> : <FaEye />}
                </button>
              </div>
            </div>

            <div className="detail-field">
              <label>이메일</label>
              <input type="email" name="email" value={selected.email} onChange={handleChange} />
            </div>

            <div className="detail-field">
              <label>전화번호</label>
              <input name="phone" value={selected.phone} onChange={handleChange} placeholder="010-0000-0000" />
            </div>

            <div className="detail-field">
              <label>주민번호</label>
              <input name="rrn" value={selected.rrn} onChange={handleChange} placeholder="######-#######" />
            </div>

            <div className="detail-field">
              <label>회원 분류</label>
              <CustomSelect
                value={selected.category}
                options={categoryOptions}
                onChange={(val) => updateMemberField("category", val)}
              />
            </div>

            <div className="detail-field">
              <label>상태</label>
              <CustomSelect
                value={selected.status}
                options={statusOptions}
                onChange={(val) => updateMemberField("status", val)}
              />
            </div>

            <button className="update-btn" onClick={handleUpdate}>저장</button>
          </>
        ) : (
          <p className="empty">수정할 회원을 선택해주세요.</p>
        )}
      </div>

      <div className="members-chart">
        <div className="chart-header">월별 유저 증감 추이</div>
        <div className="chart-area">
          <canvas ref={chartRef} />
        </div>
      </div>
    </div>
  );
};

export default MembersUser;
