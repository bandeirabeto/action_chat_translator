async function fetchMessages() {
  const res = await fetch("/messages");
  const data = await res.json();

  const chat = document.getElementById("chat");
  chat.innerHTML = "";

  data.forEach(msg => {
    const div = document.createElement("div");
    div.className = "message";
    div.classList.add(msg.status === "translated" ? "from-interviewer" : "from-user");

    div.innerHTML = `
      <div><strong>${msg.status === "translated" ? "Entrevistador" : "Você"}</strong></div>
      <div>${msg.translated}</div>
      <div class="status">${msg.status}</div>
    `;

    chat.appendChild(div);
  });

  chat.scrollTop = chat.scrollHeight;
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
  fetchMessages();
}

setInterval(fetchMessages, 3000);
fetchMessages();
