document.addEventListener("DOMContentLoaded", () => {
  const buttons = document.querySelectorAll(".slot-btn, .calendar-slot-btn");
  const slotInput = document.getElementById("reservation_slot_id");

  buttons.forEach(button => {
    button.addEventListener("click", () => {
      if (button.disabled) return; // 予約済み枠は選択不可
      
      // 全てのボタンからselectedクラスを削除
      buttons.forEach(btn => btn.classList.remove("selected"));
      
      // クリックされたボタンにselectedクラスを追加
      button.classList.add("selected");
      slotInput.value = button.dataset.slotId;
    });
  });
});
