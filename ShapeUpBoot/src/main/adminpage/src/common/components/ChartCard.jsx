import React, { useEffect, useRef } from "react";
import Chart from "chart.js/auto";
import "../styles/ChartCard.css";

const DEFAULT_LABELS = ["월", "화", "수", "목", "금", "토", "일"];

const ChartCard = ({ title, data, labels = DEFAULT_LABELS }) => {
  const chartRef = useRef(null);
  const chartInstanceRef = useRef(null);

  useEffect(() => {
    if (!chartRef.current) return;

    const ctx = chartRef.current.getContext("2d");

    if (chartInstanceRef.current) {
      chartInstanceRef.current.destroy();
    }

    chartInstanceRef.current = new Chart(ctx, {
      type: "line",
      data: {
        labels,
        datasets: [
          {
            label: title,
            data: data,
            borderWidth: 2,
            borderColor: "#007bff",
            fill: false,
          },
        ],
      },
      options: { responsive: true, maintainAspectRatio: false },
    });

    return () => {
      if (chartInstanceRef.current) {
        chartInstanceRef.current.destroy();
        chartInstanceRef.current = null;
      }
    };
  }, [data, title]);

  return (
    <div className="chart-card">
      <div className="chart-title">{title}</div>
      <div className="chart-area">
        <canvas ref={chartRef}></canvas>
      </div>
    </div>
  );
};

export default ChartCard;
