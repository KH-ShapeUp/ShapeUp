// src/stadium/pages/FacilityEdit.jsx
import React, { useState } from "react";
import "../styles/FacilityEdit.css";

const FacilityEdit = () => {
  const [timeSlots, setTimeSlots] = useState([
    "09:00 - 10:00",
    "10:00 - 11:00",
    "11:00 - 12:00",
    "12:00 - 13:00",
    "13:00 - 14:00",
    "14:00 - 15:00",
    "15:00 - 16:00",
    "16:00 - 17:00",
  ]);

  const addTimeSlot = () => setTimeSlots([...timeSlots, ""]);
  const removeTimeSlot = (idx) =>
    setTimeSlots(timeSlots.filter((_, i) => i !== idx));
  const updateTime = (idx, value) => {
    const updated = [...timeSlots];
    updated[idx] = value;
    setTimeSlots(updated);
  };

  return (
    <div className="facility-edit-container">
      {/* 좌측 - 시설 등록 */}
      <div className="facility-card">
        <h3>시설 등록</h3>
        <div className="form-group">
          <label>시설명</label>
          <input type="text" placeholder="시설명을 입력하세요" />
        </div>
        <div className="form-group">
          <label>시설 위치</label>
          <input type="text" placeholder="시설 위치를 입력하세요" />
        </div>
        <div className="form-group">
          <label>시설 설명</label>
          <textarea placeholder="시설 설명을 입력하세요" />
        </div>
        <div className="btn-area">
          <button className="submit-btn">등록</button>
        </div>
      </div>

      {/* 우측 - 시설 수정 */}
      <div className="facility-card">
        <h3>시설 수정</h3>

        <div className="form-group">
          <label>수정할 시설</label>
          <select>
            <option>시설 1</option>
            <option>시설 2</option>
          </select>
        </div>

        <div className="form-group">
          <label>시설명</label>
          <input type="text" />
        </div>

        <div className="form-group">
          <label>시설 위치</label>
          <input type="text" />
        </div>

        <div className="form-group">
          <label>시설 설명</label>
          <textarea />
        </div>

        <div className="btn-area">
          <button className="submit-btn">수정</button>
        </div>

        {/* 시간대 수정 */}
        <div className="time-edit-section">
          <div className="time-header">
            <h4>시간대 수정</h4>
            <button className="add-btn" onClick={addTimeSlot}>＋</button>
          </div>
          <div className="time-list">
            {timeSlots.map((time, idx) => (
              <div key={idx} className="time-item">
                <input
                  type="text"
                  value={time}
                  onChange={(e) => updateTime(idx, e.target.value)}
                />
                <button
                  className="remove-btn"
                  onClick={() => removeTimeSlot(idx)}
                >
                  −
                </button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default FacilityEdit;
