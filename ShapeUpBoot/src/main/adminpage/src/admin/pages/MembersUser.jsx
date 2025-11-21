import React, { useEffect, useMemo, useRef, useState } from "react";
import { FaEye, FaEyeSlash } from "react-icons/fa";
import Chart from "chart.js/auto";
import "../styles/MembersUser.css";
import CustomSelect from "../../common/components/CustomSelect";
const userTypeLabels = {
  USER: "유저",
  SYSTEM_MANAGER: "어드민",
  TRAINER: "트레이너",
  STADIUM_MANAGER: "시설 관리자",
};

const deriveGenderFromRrn = (rrn) => {
  const digit = rrn?.trim()?.replace(/[^0-9]/g, "").slice(-1);
  if (digit === "2" || digit === "4" || digit === "0") return "여";
  if (digit === "1" || digit === "3") return "남";
  return "";
};

const deriveAgeFromRrn = (rrn) => {
  const clean = rrn?.trim()?.replace(/[^0-9]/g, "");
  if (!clean || clean.length < 7) return null;
  const yy = clean.slice(0, 2);
  const mm = clean.slice(2, 4);
  const dd = clean.slice(4, 6);
  const genderDigit = clean[6];
  const baseCentury = genderDigit === "1" || genderDigit === "2" ? 1900 : 2000;
  let year = baseCentury + Number(yy);
  const currentYear = new Date().getFullYear();
  if (year > currentYear) {
    year -= 100; // 미래 연도 방지 (예: 2097 -> 1997)
  }
  const month = Number(mm) - 1;
  const day = Number(dd);
  const birth = new Date(year, month, day);
  if (Number.isNaN(birth.getTime())) return null;
  const today = new Date();
  let age = today.getFullYear() - birth.getFullYear();
  const m = today.getMonth() - birth.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) age -= 1;
  return age;
};

const formatPhone = (phone) => {
  const digits = (phone ?? "").replace(/[^0-9]/g, "").slice(0, 11);
  if (digits.length <= 3) return digits;
  if (digits.length <= 7) return `${digits.slice(0, 3)}-${digits.slice(3)}`;
  return `${digits.slice(0, 3)}-${digits.slice(3, 7)}-${digits.slice(7)}`;
};

const mapUserToMember = (user) => ({
  id: user.userNo,
  name: user.userName ?? "",
  age: user.userAge ?? deriveAgeFromRrn(user.userSerialNo) ?? 0,
  nickname: user.userNickname ?? "",
  joinedAt: user.createdAt?.slice(0, 10) ?? "",
  updatedAt: user.updatedAt ?? "",
  createdAt: user.createdAt ?? "",
  userType: user.userType ?? "USER",
  status: user.status ?? "정상",
  gender: deriveGenderFromRrn(user.userSerialNo),
  username: user.userId ?? "",
  // 수정 화면에는 기존 해시를 표시하지 않고 빈 값으로 둔다
  password: "",
  email: user.userEmail ?? "",
  phone: formatPhone(user.userPhone),
  rrn: user.userSerialNo ?? "",
});

const searchFieldOptions = ["전체", "아이디", "비밀번호", "이름", "나이", "닉네임"];
const pageSizeOptions = ["5", "10", "30", "50"];
const genderOptions = [
  { label: "남", value: "남" },
  { label: "여", value: "여" },
];
const categoryOptions = [
  { label: "유저", value: "USER" },
  { label: "트레이너", value: "TRAINER" },
  { label: "어드민", value: "SYSTEM_MANAGER" },
  { label: "시설 관리자", value: "STADIUM_MANAGER" },
];
const statusOptions = [
  { label: "정상", value: "정상" },
  { label: "정지", value: "정지" },
  { label: "탈퇴", value: "탈퇴" },
];

const MembersUser = () => {
  const [members, setMembers] = useState([]);
  const [selectedId, setSelectedId] = useState(null);
  const [baseSelected, setBaseSelected] = useState(null); // 저장된 기준 상태
  const [dirtyFields, setDirtyFields] = useState({});
  const [showPassword, setShowPassword] = useState(false);
  const [sort, setSort] = useState({ key: "id", dir: "asc" });
  const [searchField, setSearchField] = useState("전체");
  const [searchText, setSearchText] = useState("");
  const [pageSize, setPageSize] = useState(10);
  const [page, setPage] = useState(1);
  const [pageInput, setPageInput] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showSaveModal, setShowSaveModal] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [inlineMessage, setInlineMessage] = useState(null);
  const [banDuration, setBanDuration] = useState({ value: "", unit: "day" }); // unit: day/month/year
  const chartRef = useRef(null);
  const chartInstanceRef = useRef(null);

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
        const first = mapped[0] ?? null;
        setSelectedId(first?.id ?? null);
        setBaseSelected(first);
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
      case "category": return userTypeLabels[m.userType] ?? "";
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
  const selected = useMemo(() => sorted.find((m) => m.id === selectedId) || null, [sorted, selectedId]);
   useEffect(() => {
     if (selected?.status === "정지") {
       setBanDuration((prev) => ({ ...prev, value: prev.value || "" }));
     } else {
       setBanDuration({ value: "", unit: "day" });
    }
  }, [selected?.status]);

  useEffect(() => {
    setPage(1);
    setPageInput("");
  }, [searchField, searchText, pageSize]);

  useEffect(() => {
    setPage((prev) => Math.min(prev, totalPages));
  }, [totalPages]);

  // 가입일 기반 일별 가입자 그래프 (최근 7일)
  useEffect(() => {
    if (!chartRef.current) return;
    const ctx = chartRef.current.getContext("2d");

    const today = new Date();
    const dates = [];
    for (let i = 6; i >= 0; i -= 1) {
      const d = new Date(today);
      d.setDate(today.getDate() - i);
      const iso = d.toISOString().slice(0, 10); // YYYY-MM-DD
      dates.push(iso);
    }

    const dayCount = new Map(dates.map((d) => [d, 0]));
    members.forEach((m) => {
      const raw = m.createdAt || m.joinedAt;
      if (!raw) return;
      let dateKey;
      const parsed = new Date(raw);
      if (!Number.isNaN(parsed.getTime())) {
        dateKey = parsed.toISOString().slice(0, 10);
      } else if (typeof raw === "string") {
        dateKey = raw.slice(0, 10);
      }
      if (dateKey && dayCount.has(dateKey)) {
        dayCount.set(dateKey, (dayCount.get(dateKey) || 0) + 1);
      }
    });
    const labels = dates;
  const values = dates.map((d) => dayCount.get(d) || 0);

  if (chartInstanceRef.current) {
    chartInstanceRef.current.destroy();
  }

    chartInstanceRef.current = new Chart(ctx, {
      type: "line",
      data: {
        labels,
        datasets: [
          {
            label: "일일 가입자 수",
            data: values,
            borderColor: "#4c8bf5",
            backgroundColor: "rgba(76, 139, 245, 0.15)",
            borderWidth: 3,
            pointRadius: 4,
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

    return () => {
      if (chartInstanceRef.current) chartInstanceRef.current.destroy();
    };
  }, [members]);

  useEffect(() => {
    if (selectedId == null) return;
    if (!members.some((member) => member.id === selectedId)) {
      setSelectedId(members[0]?.id ?? null);
      setBaseSelected(members[0] ?? null);
    } else {
      const hit = members.find((member) => member.id === selectedId) || null;
      // 선택된 사용자가 바뀐 경우에만 기준 상태를 갱신 (입력 중 덮어쓰기 방지)
      if (!baseSelected || baseSelected.id !== selectedId) {
        setBaseSelected(hit);
        setDirtyFields({});
      }
    }
  }, [members, selectedId, baseSelected]);

  // 저장된 기준과 비교해 변경 필드 기록
  useEffect(() => {
    if (!selected || !baseSelected) {
      setDirtyFields({});
      return;
    }
    const nextDirty = {};
    const fieldsToCheck = [
      "username",
      "name",
      "nickname",
      "email",
      "phone",
      "userType",
      "status",
      "password",
      "rrn",
      "age",
    ];
    fieldsToCheck.forEach((field) => {
      if ((selected[field] ?? "") !== (baseSelected[field] ?? "")) {
        nextDirty[field] = true;
      }
    });
    setDirtyFields(nextDirty);
  }, [selected, baseSelected]);

  // 페이지 벗어날 때 경고 + 내비게이션 링크 클릭 차단
  useEffect(() => {
    const hasDirty = Object.keys(dirtyFields).length > 0;
    const beforeUnload = (e) => {
      if (!hasDirty) return;
      e.preventDefault();
      e.returnValue = "";
    };
    const clickBlocker = (e) => {
      if (!hasDirty) return;
      const anchor = e.target.closest("a");
      if (!anchor) return;
      const href = anchor.getAttribute("href");
      if (!href || href.startsWith("#")) return;
      const confirmed = window.confirm("변경된 사항이 있습니다. 저장하지 않고 이동하시겠습니까?");
      if (!confirmed) {
        e.preventDefault();
        e.stopPropagation();
      }
    };
    window.addEventListener("beforeunload", beforeUnload);
    window.addEventListener("click", clickBlocker);
    return () => {
      window.removeEventListener("beforeunload", beforeUnload);
      window.removeEventListener("click", clickBlocker);
    };
  }, [dirtyFields]);

  const updateMembers = (updater) => {
    setMembers((prev) => (typeof updater === "function" ? updater(prev) : updater));
  };

  const computeBanDays = () => {
    if (selected?.status !== "정지") return null;
    const num = Number(banDuration.value);
    if (!Number.isFinite(num) || num <= 0) return null;
    const factor = banDuration.unit === "month" ? 30 : banDuration.unit === "year" ? 365 : 1;
    return Math.round(num * factor);
  };

  const handleSelect = (id) => {
    setInlineMessage(null);
    setShowSaveModal(false);
    setSelectedId(id);
  };
  const updateMemberField = (name, value) => {
    if (!selected) return;
    updateMembers((prev) =>
      prev.map((m) => {
        if (m.id !== selected.id) return m;
        if (name === "rrn") {
          const gender = deriveGenderFromRrn(value);
          const age = deriveAgeFromRrn(value);
          return { ...m, rrn: value, gender: gender || m.gender, age: age ?? m.age };
        }
        return { ...m, [name]: value };
      })
    );
    setDirtyFields((prev) => ({ ...prev, [name]: true }));
    setInlineMessage(null);
  };
  const handleChange = (e) => {
    const { name, value } = e.target;
    if (name === "phone") {
      updateMemberField(name, formatPhone(value));
    } else {
      updateMemberField(name, value);
    }
  };
  const handleUpdate = () => {
    if (!selected) return;
    const hasDirty = Object.keys(dirtyFields).length > 0;
    if (!hasDirty) {
      setInlineMessage({ type: "error", text: "변동된 사항이 없습니다." });
      return;
    }
    if (selected.status === "정지") {
      const days = computeBanDays();
      if (!days) {
        setInlineMessage({ type: "error", text: "차단 기간을 입력하세요." });
        return;
      }
    }
    setInlineMessage(null);
    setShowSaveModal(true);
  };

  const performSave = async () => {
    if (!selected) return;
    setIsSaving(true);
    setInlineMessage(null);
    const tasks = [];
    // 프로필 업데이트 (아이디, 이름, 닉네임, 이메일, 전화번호)
    tasks.push(
      fetch(`/api/admin/users/${selected.id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          userId: selected.username,
          userName: selected.name,
          userNickname: selected.nickname,
          userEmail: selected.email,
          userPhone: selected.phone,
          userSerialNo: selected.rrn,
          userAge: selected.age ?? null,
        }),
      })
    );
    if (selected.status) {
      let statusUrl = `/api/admin/users/${selected.id}/status?status=${encodeURIComponent(selected.status)}`;
      if (selected.status === "정지") {
        const banDays = computeBanDays();
        if (banDays) statusUrl += `&banDays=${banDays}`;
      }
      tasks.push(fetch(statusUrl, { method: "PATCH" }));
    }
    if (selected.userType) {
      tasks.push(fetch(`/api/admin/users/${selected.id}/type?userType=${encodeURIComponent(selected.userType)}`, { method: "PATCH" }));
    }
    if (selected.password && selected.password.trim()) {
      tasks.push(fetch(`/api/admin/users/${selected.id}/password?password=${encodeURIComponent(selected.password)}`, { method: "PATCH" }));
    }

    try {
      const responses = await Promise.all(tasks);
      const failed = responses.find((res) => !res.ok);
      if (failed) throw new Error("저장 중 오류가 발생했습니다.");

      const res = await fetch("/api/admin/users");
      if (!res.ok) throw new Error("회원 목록을 새로고침하지 못했습니다.");
      const data = await res.json();
      const mapped = Array.isArray(data) ? data.map(mapUserToMember) : [];
      setMembers(mapped);
      const nextSelected = mapped.find((m) => m.id === selected.id) ?? mapped[0] ?? null;
      setSelectedId(nextSelected?.id ?? null);
      setBaseSelected(nextSelected);
      setShowPassword(false);
      setDirtyFields({});
      setInlineMessage({ type: "success", text: "저장되었습니다." });
    } catch (err) {
      console.error(err);
      setInlineMessage({ type: "error", text: "저장에 실패했습니다." });
    } finally {
      setIsSaving(false);
      setShowSaveModal(false);
    }
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
                <td>{userTypeLabels[m.userType] ?? m.userType}</td>
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
              <input
                name="name"
                value={selected.name}
                onChange={handleChange}
                className={dirtyFields.name ? "dirty-field" : ""}
              />
            </div>

            <div className="detail-field">
              <label>닉네임</label>
              <input
                name="nickname"
                value={selected.nickname}
                onChange={handleChange}
                className={dirtyFields.nickname ? "dirty-field" : ""}
              />
            </div>

            <div className="detail-field">
              <label>성별</label>
              <CustomSelect value={selected.gender} options={genderOptions} disabled />
            </div>

            <div className="detail-field">
              <label>아이디</label>
              <input
                name="username"
                value={selected.username}
                onChange={handleChange}
                className={dirtyFields.username ? "dirty-field" : ""}
              />
            </div>

            <div className="detail-field">
              <label>비밀번호</label>
              <div className="password-input">
                <input
                  type={showPassword ? "text" : "password"}
                  name="password"
                  value={selected.password}
                  onChange={handleChange}
                  className={dirtyFields.password ? "dirty-field" : ""}
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
              <input
                name="rrn"
                value={selected.rrn}
                onChange={handleChange}
                placeholder="######-#######"
                className={dirtyFields.rrn ? "dirty-field" : ""}
              />
            </div>

            <div className="detail-field">
              <label>회원 분류</label>
              <CustomSelect
                value={selected.userType}
                options={categoryOptions}
                onChange={(val) => updateMemberField("userType", val)}
                className={dirtyFields.userType ? "dirty-field" : ""}
              />
            </div>

            <div className="detail-field">
              <label>상태</label>
              <CustomSelect
                value={selected.status}
                options={statusOptions}
                onChange={(val) => updateMemberField("status", val)}
                className={dirtyFields.status ? "dirty-field" : ""}
              />
            </div>

            {selected.status === "정지" && (
              <>
                <div className="detail-field">
                  <label>해제 날짜</label>
                  <input
                    value={
                      selected.updatedAt
                        ? new Date(selected.updatedAt).toISOString().slice(0, 10)
                        : ""
                    }
                    readOnly
                    style={{ background: "#f5f6fb" }}
                  />
                </div>
                <div className="detail-field">
                  <label>차단 기간</label>
                  <div className="ban-duration">
                    <input
                      type="number"
                      min="1"
                      value={banDuration.value}
                      onChange={(e) => {
                        const val = e.target.value;
                        setBanDuration((prev) => ({ ...prev, value: val }));
                        if (val) setDirtyFields((prev) => ({ ...prev, status: true }));
                      }}
                      placeholder="기간"
                    />
                    <CustomSelect
                      value={banDuration.unit}
                      options={[
                        { label: "일", value: "day" },
                        { label: "달", value: "month" },
                        { label: "년", value: "year" },
                      ]}
                      onChange={(val) => setBanDuration((prev) => ({ ...prev, unit: val }))}
                      size="sm"
                    />
                    <span className="ban-text">차단</span>
                  </div>
                </div>
              </>
            )}

            <button className="update-btn" onClick={handleUpdate}>저장</button>
            {inlineMessage && (
              <div className={`inline-message ${inlineMessage.type}`}>{inlineMessage.text}</div>
            )}
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

      {showSaveModal && (
        <div className="save-modal">
          <div className="save-modal__box">
            <p className="save-modal__title">저장하시겠습니까?</p>
            <div className="save-modal__actions">
              <button type="button" className="modal-btn secondary" onClick={() => setShowSaveModal(false)} disabled={isSaving}>
                아니오
              </button>
              <button type="button" className="modal-btn primary" onClick={performSave} disabled={isSaving}>
                예
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default MembersUser;
