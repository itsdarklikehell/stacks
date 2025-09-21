function showTab(tab) {
  document
    .querySelectorAll(".tab-section")
    .forEach((s) => s.classList.remove("active"));
  document.getElementById("tab-" + tab).classList.add("active");
}

async function refreshBotStatus() {
  const res = await fetch("/api/bot-status");
  document.getElementById("bot-status").textContent = await res.text();
}
async function refreshBotLogs() {
  const res = await fetch("/api/bot-logs");
  document.getElementById("bot-logs").textContent = await res.text();
}
async function refreshBotChat() {
  const res = await fetch("/api/bot-chat");
  document.getElementById("bot-chat").textContent = await res.text();
}

async function refreshTVS99Config() {
  const res = await fetch("/api/tvs99-config");
  try {
    const data = await res.json();
    document.getElementById("tvs99-config").textContent = JSON.stringify(
      data,
      null,
      2
    );
  } catch {
    document.getElementById("tvs99-config").textContent = await res.text();
  }
}
async function refreshTVS99Programming() {
  const res = await fetch("/api/tvs99-programming");
  try {
    const data = await res.json();
    document.getElementById("tvs99-programming").textContent = JSON.stringify(
      data,
      null,
      2
    );
  } catch {
    document.getElementById("tvs99-programming").textContent = await res.text();
  }
}
async function refreshMedia() {
  const res = await fetch("/api/media");
  try {
    const data = await res.json();
    document.getElementById("media-list").textContent = JSON.stringify(
      data,
      null,
      2
    );
  } catch {
    document.getElementById("media-list").textContent = await res.text();
  }
}

// Initial load
refreshBotStatus();
refreshBotLogs();
refreshBotChat();
refreshTVS99Config();
refreshTVS99Programming();
refreshMedia();

// Optionally, poll for live updates
setInterval(refreshBotChat, 3000);
