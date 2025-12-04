import React, { useEffect, useMemo, useState } from "react";
import "../styles/RoleRequests.css";
import CustomSelect from "../../common/components/CustomSelect";

  const roleLabel = {
    TRAINER: "트레이너",
    STADIUM_MANAGER: "시설 관리자",
    USER: "유저",
    SYSTEM_MANAGER: "어드민",
};

const RoleBadge = ({ status }) => (
  <span className={`role-badge ${status === "대기" ? "pending" : status === "승인" ? "approved" : "rejected"}`}>
    {status}
  </span>
);

const MembersRoleRequest = () => {
  const [pending, setPending] = useState([]);
  const [done, setDone] = useState([]);
  const [selectedId, setSelectedId] = useState(null);
  const [showApproveModal, setShowApproveModal] = useState(false);
  const [showRejectModal, setShowRejectModal] = useState(false);
  const [showDoneModal, setShowDoneModal] = useState(false);
  const [selectedDone, setSelectedDone] = useState(null);
  const [toast, setToast] = useState(null);
  const [rejectReason, setRejectReason] = useState("");
  const [approveNote, setApproveNote] = useState("");
  // pagination - pending/done
  const [pendingPage, setPendingPage] = useState(1);
  const [pendingSize, setPendingSize] = useState(10);
  const [pendingPageInput, setPendingPageInput] = useState("");
  const [donePage, setDonePage] = useState(1);
  const [doneSize, setDoneSize] = useState(10);
  const [donePageInput, setDonePageInput] = useState("");
  const [pendingSearch, setPendingSearch] = useState("");
  const [doneSearch, setDoneSearch] = useState("");

  const selected = useMemo(() => pending.find((p) => p.id === selectedId) ?? null, [pending, selectedId]);
  const matchesSearch = (row, term) => {
    const t = term.trim().toLowerCase();
    if (!t) return true;
    return [row.name, row.username, row.requestedRole, row.status]
      .filter(Boolean)
      .some((field) => String(field).toLowerCase().includes(t));
  };

  const filteredPending = useMemo(
    () => pending.filter((row) => matchesSearch(row, pendingSearch)),
    [pending, pendingSearch]
  );
  const filteredDone = useMemo(
    () => done.filter((row) => matchesSearch(row, doneSearch)),
    [done, doneSearch]
  );

  const pendingTotalPages = Math.max(1, Math.ceil(filteredPending.length / pendingSize));
  const pendingPageItems = useMemo(() => {
    const start = (pendingPage - 1) * pendingSize;
    return filteredPending.slice(start, start + pendingSize);
  }, [filteredPending, pendingPage, pendingSize]);
  const doneTotalPages = Math.max(1, Math.ceil(filteredDone.length / doneSize));
  const donePageItems = useMemo(() => {
    const start = (donePage - 1) * doneSize;
    return filteredDone.slice(start, start + doneSize);
  }, [filteredDone, donePage, doneSize]);

  useEffect(() => {
    setPendingPage((p) => Math.min(p, pendingTotalPages));
  }, [pendingTotalPages]);
  useEffect(() => {
    setDonePage((p) => Math.min(p, doneTotalPages));
  }, [doneTotalPages]);

  useEffect(() => {
    const load = async () => {
      try {
        const res = await fetch("/api/admin/permissions/requests?status=대기");
        const json = await res.json();
        const rows = json.data || [];
        const mapped = rows.map((r) => ({
          id: r.requestNo,
          name: r.userName,
          username: r.userId,
          requestedRole: roleLabel[r.requestType] || r.requestType,
          reason: r.requestReason,
          status: r.requestStatus,
          fromRole: "유저",
          certNumber: r.certificateNumber,
          certName: r.certificateType,
          certDetail: r.requestReason,
          businessNumber: r.businessNumber,
          businessName: r.businessName,
          businessDetail: r.requestReason,
          attachmentPath: r.attachmentPath,
          attachmentOrigin: r.attachmentOrigin,
          attachmentRename: r.attachmentRename,
        }));
        setPending(mapped);
        setSelectedId(mapped[0]?.id ?? null);
      } catch (err) {
        console.error(err);
      }

      try {
        const res = await fetch("/api/admin/permissions/requests?status=");
        const json = await res.json();
        const rows = (json.data || []).filter((r) => r.requestStatus !== "대기");
        const mapped = rows.map((r) => ({
          id: r.requestNo,
          name: r.userName,
          username: r.userId,
          requestedRole: roleLabel[r.requestType] || r.requestType,
          reason: r.rejectReason || r.requestReason,
          status: r.requestStatus,
          certNumber: r.certificateNumber,
          certName: r.certificateType,
          certDetail: r.requestReason,
          businessNumber: r.businessNumber,
          businessName: r.businessName,
          businessDetail: r.requestReason,
          attachmentPath: r.attachmentPath,
          attachmentOrigin: r.attachmentOrigin,
          attachmentRename: r.attachmentRename,
        }));
        setDone(mapped);
      } catch (err) {
        console.error(err);
      }
    };
    load();
  }, []);

  const showToast = (msg) => {
    setToast(msg);
    setTimeout(() => setToast(null), 1000);
  };

  const handleApprove = () => {
    setShowApproveModal(true);
  };
  const confirmApprove = () => {
    if (!selected) return;
    fetch(`/api/admin/permissions/requests/${selected.id}/approve`, { method: "POST", headers: { "Content-Type": "application/json" } })
      .then(() => {
        const updatedPending = pending.filter((p) => p.id !== selected.id);
        const approved = { ...selected, status: "승인", reason: approveNote || "권한 승인 완료" };
        setPending(updatedPending);
        setDone((prev) => [approved, ...prev]);
        setSelectedId(updatedPending[0]?.id ?? null);
        setShowApproveModal(false);
        setApproveNote("");
        showToast("승인되었습니다.");
      })
      .catch(console.error);
  };

  const handleReject = () => {
    setRejectReason("");
    setShowRejectModal(true);
  };
  const confirmReject = () => {
    if (!selected) return;
    fetch(`/api/admin/permissions/requests/${selected.id}/reject`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ rejectReason: rejectReason || "반려 처리" })
    }).then(() => {
      const updatedPending = pending.filter((p) => p.id !== selected.id);
      const rejected = { ...selected, status: "반려", reason: rejectReason || "반려 처리" };
      setPending(updatedPending);
      setDone((prev) => [rejected, ...prev]);
      setSelectedId(updatedPending[0]?.id ?? null);
      setShowRejectModal(false);
      showToast("반려되었습니다.");
    }).catch(console.error);
  };

  const openDoneDetail = (row) => {
    setSelectedDone(row);
    setShowDoneModal(true);
  };

  const renderRoleExtra = (req) => {
    if (!req) return null;
    const attachmentUrl = req.attachmentPath || (req.attachmentRename && req.username
      ? `/uploads/request/${req.username}/${req.attachmentRename}`
      : null);
    const attachmentLabel = req.attachmentOrigin || req.attachmentRename || (attachmentUrl ? "증빙서류 보기" : null);

    if (req.requestedRole === "트레이너") {
      return (
        <>
          <div className="detail-row">
            <label>자격증 번호</label>
            <div className="value">{req.certNumber ?? "-"}</div>
          </div>
          <div className="detail-row">
            <label>자격증 이름</label>
            <div className="value">{req.certName ?? "-"}</div>
          </div>
          <div className="detail-row">
            <label>자격증 상세</label>
            <div className="value reason">{req.certDetail ?? "-"}</div>
          </div>
          <div className="detail-row">
            <label>증빙서류</label>
            <div className="value">
              {attachmentUrl ? (
                <a className="attach-link" href={attachmentUrl} target="_blank" rel="noreferrer">
                  {attachmentLabel || "파일 열기"}
                </a>
              ) : (
                "-"
              )}
            </div>
          </div>
        </>
      );
    }
    if (req.requestedRole === "시설 관리자") {
      return (
        <>
          <div className="detail-row">
            <label>사업자등록번호</label>
            <div className="value">{req.businessNumber ?? "-"}</div>
          </div>
          <div className="detail-row">
            <label>사업장 이름</label>
            <div className="value">{req.businessName ?? "-"}</div>
          </div>
          <div className="detail-row">
            <label>사업장 상세</label>
            <div className="value reason">{req.businessDetail ?? "-"}</div>
          </div>
          <div className="detail-row">
            <label>증빙서류</label>
            <div className="value">
              {attachmentUrl ? (
                <a className="attach-link" href={attachmentUrl} target="_blank" rel="noreferrer">
                  {attachmentLabel || "파일 열기"}
                </a>
              ) : (
                "-"
              )}
            </div>
          </div>
        </>
      );
    }
    return null;
  };

  return (
    <div className="role-requests">
          <header className="title-header">
        <div>
          <h2>권한 관리</h2>
          <p>권한 요청을 확인하고, 권한을 부여하거나 반려할 수 있어요.</p>
        </div>
      </header>
      <div className="role-requests__top">
        <div className="pending-card">
          <div className="section-header">
            <div>
              <h3>권한 요청</h3>            
            </div>
            <div className="header-actions">
              <div className="count-pill">대기 {pending.length}명</div>
              <CustomSelect
                className="page-size-select"
                value={String(pendingSize)}
                options={[5, 10, 20, 50].map((sz) => ({ label: `${sz}개`, value: String(sz) }))}
                onChange={(val) => { setPendingSize(Number(val)); setPendingPage(1); }}
                size="sm"
              />
              <input
                type="text"
                className="search-input"
                placeholder="검색어 입력"
                value={pendingSearch}
                onChange={(e) => { setPendingSearch(e.target.value); setPendingPage(1); }}
              />
            </div>              

          </div>
          <div className="pending-list">
            {pending.length === 0 ? (
              <div className="empty">대기 중인 요청이 없습니다.</div>
            ) : (
              pendingPageItems.map((req) => (
                <div
                  key={req.id}
                  className={`pending-item ${selectedId === req.id ? "active" : ""}`}
                  onClick={() => setSelectedId(req.id)}
                >
                  <div className="pending-item__top">
                    <span className="pending-name">{req.name}</span>
                    <RoleBadge status={req.status} />
                  </div>
                  <div className="pending-meta">
                    <span>아이디: {req.username}</span>
                    <span>요청 권한: {req.requestedRole}</span>
                  </div>
                </div>
              ))
            )}
          </div>
          {pending.length > 0 && (
            <div className="pagination-controls">
              <button
                type="button"
                onClick={() => setPendingPage((p) => Math.max(1, p - 1))}
                disabled={pendingPage === 1}
              >
                이전
              </button>
              <span className="pagination-status">{pendingPage}/{pendingTotalPages}</span>
              <input
                type="number"
                min="1"
                max={pendingTotalPages}
                className="pagination-input"
                value={pendingPageInput}
                placeholder="페이지 입력"
                onChange={(e) => setPendingPageInput(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter") {
                    const v = Number(e.currentTarget.value);
                    if (!Number.isNaN(v) && v >= 1 && v <= pendingTotalPages) {
                      setPendingPage(v);
                      setPendingPageInput("");
                    }
                  }
                }}
              />
              <button
                type="button"
                onClick={() => setPendingPage((p) => Math.min(pendingTotalPages, p + 1))}
                disabled={pendingPage === pendingTotalPages}
              >
                다음
              </button>

            </div>
          )}
        </div>

        <div className="detail-card">
          <div className="section-header">
            <div>
              <h3>회원 상태 수정</h3>
            </div>
          </div>
          {selected ? (
          <div className="detail-body">
            <div className="detail-row">
              <label>이름</label>
              <div className="value">{selected.name}</div>
            </div>
            <div className="detail-row">
              <label>요청 권한</label>
              <div className="value">{selected.requestedRole}</div>
            </div>
            {renderRoleExtra(selected)}
            <div className="detail-row">
              <label>권한 요청 이유</label>
              <div className="value reason">{selected.reason}</div>
            </div>
            <div className="detail-actions">
              <button className="btn-ghost" type="button" onClick={handleReject}>반려</button>
              <button className="btn-primary" type="button" onClick={handleApprove}>승인</button>
            </div>
          </div>
          ) : (
            <div className="empty">선택된 요청이 없습니다.</div>
          )}
        </div>
      </div>

        <div className="completed-card">
          <div className="section-header">
            <div>
              <h3>완료된 사항</h3>
            </div>
          <div className="header-actions">
            <div className="count-pill alt">완료 {done.length}건</div>
            <CustomSelect
              className="page-size-select"
              value={String(doneSize)}
              options={[5, 10, 20, 50].map((sz) => ({ label: `${sz}개`, value: String(sz) }))}
              onChange={(val) => { setDoneSize(Number(val)); setDonePage(1); }}
              size="sm"
            />
            <input
              type="text"
              className="search-input"
              placeholder="검색어 입력"
              value={doneSearch}
              onChange={(e) => { setDoneSearch(e.target.value); setDonePage(1); }}
            />
          </div>
        </div>
        <div className="table-wrap">
          <table className="role-table">
            <thead>
              <tr>
                <th>번호</th>
                <th>이름</th>
                <th>아이디</th>
                <th>요청 권한</th>
                <th>상태</th>
              </tr>
            </thead>
            <tbody>
              {done.length === 0 ? (
                <tr><td colSpan={5} className="empty">완료된 요청이 없습니다.</td></tr>
              ) : (
                donePageItems.map((row) => (
                  <tr key={row.id} className="clickable" onClick={() => openDoneDetail(row)}>
                    <td>{row.id}</td>
                    <td>{row.name}</td>
                    <td>{row.username}</td>
                    <td>{row.requestedRole}</td>
                    <td><RoleBadge status={row.status} /></td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
          {done.length > 0 && (
            <div className="pagination-controls">
              <button
                type="button"
                onClick={() => setDonePage((p) => Math.max(1, p - 1))}
                disabled={donePage === 1}
              >
                이전
              </button>
              <span className="pagination-status">{donePage}/{doneTotalPages}</span>
              <input
                type="number"
                min="1"
                max={doneTotalPages}
                className="pagination-input"
                value={donePageInput}
                placeholder="페이지 입력"
                onChange={(e) => setDonePageInput(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter") {
                    const v = Number(e.currentTarget.value);
                    if (!Number.isNaN(v) && v >= 1 && v <= doneTotalPages) {
                      setDonePage(v);
                      setDonePageInput("");
                    }
                  }
                }}
              />
              <button
                type="button"
                onClick={() => setDonePage((p) => Math.min(doneTotalPages, p + 1))}
                disabled={donePage === doneTotalPages}
              >
                다음
              </button>
            </div>
          )}
        </div>
      </div>

      {showApproveModal && selected && (
        <div className="modal-backdrop role-modal">
          <div className="role-modal__box">
            <h4>승인하시겠습니까?</h4>
            <p>이름: {selected.name}</p>
            <p>아이디: {selected.username}</p>
            <p>변경 권한: {selected.fromRole} → {selected.requestedRole}</p>
            <textarea
              value={approveNote}
              onChange={(e) => setApproveNote(e.target.value)}
              placeholder="비고 (선택)"
              style={{ width: "100%", minHeight: "70px" }}
            />
            <div className="role-modal__actions">
              <button className="btn-ghost" onClick={() => setShowApproveModal(false)}>취소</button>
              <button className="btn-primary" onClick={confirmApprove}>예</button>
            </div>
          </div>
        </div>
      )}

      {showRejectModal && selected && (
        <div className="modal-backdrop role-modal">
          <div className="role-modal__box">
            <h4>반려 사유를 입력해주세요.</h4>
            <textarea
              value={rejectReason}
              onChange={(e) => setRejectReason(e.target.value)}
              placeholder="반려 사유"
            />
            <div className="role-modal__actions">
              <button className="btn-ghost" onClick={() => setShowRejectModal(false)}>취소</button>
              <button className="btn-primary" onClick={confirmReject}>예</button>
            </div>
          </div>
        </div>
      )}

      {toast && (
        <div className="role-toast">{toast}</div>
      )}

      {showDoneModal && selectedDone && (
        <div className="modal-backdrop role-modal">
          <div className="role-modal__box">
            <h4>완료된 요청 정보</h4>
            <p>번호: {selectedDone.id}</p>
            <p>이름: {selectedDone.name}</p>
            <p>아이디: {selectedDone.username}</p>
            <p>요청 권한: {selectedDone.requestedRole}</p>
            <p>처리 상태: {selectedDone.status}</p>
            {selectedDone.reason && <p>비고: {selectedDone.reason}</p>}
            {renderRoleExtra(selectedDone)}
            <div className="role-modal__actions">
              <button className="btn-primary" onClick={() => setShowDoneModal(false)}>닫기</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default MembersRoleRequest;
