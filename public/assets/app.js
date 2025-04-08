let lastMessageId = null;

async function fetchMessages() {
  const res = await fetch("/messages");
  const data = await res.json();

  const chat = document.getElementById("chat");

  const latest = data[data.length - 1];
  const isNewMessage = latest && latest.id !== lastMessageId;

  chat.innerHTML = "";

  data.forEach(msg => {
    if (msg.status === "confirmed") return;

    const div = document.createElement("div");
    div.className = "message";
    div.classList.add(msg.status === "translated" ? "from-interviewer" : "from-user");

    const isInterviewer = msg.status === "translated";
    const main = isInterviewer ? msg.translated : msg.original;
    const sub = isInterviewer ? msg.original : msg.translated;

    div.innerHTML = `
      <div class="main-text">${main}</div>
      <div class="sub-text">🇺🇸 ${sub}</div>
      ${msg.status !== "translated" ? `<div class="status-text">${msg.status}</div>` : ""}
    `;

    chat.appendChild(div);
  });

  if (isNewMessage) {
    const last = chat.lastElementChild;
    if (last) last.scrollIntoView({ behavior: "smooth" });
    lastMessageId = latest.id;
  }
}

async function sendReply() {
  const text = document.getElementById("reply").value;
  if (!text.trim()) return alert("Digite sua resposta primeiro!");

  const res = await fetch("/messages", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ text })
  });

  const msg = await res.json();

  document.getElementById("translatedText").innerText = msg.translated;
  document.getElementById("pendingReply").style.display = "block";
}

async function confirmReply() {
  await fetch("/messages/confirm", { method: "POST" });
  document.getElementById("pendingReply").style.display = "none";
  document.getElementById("reply").value = "";

  lastMessageId = null;
  fetchMessages();
}

setInterval(fetchMessages, 1000);
fetchMessages();
