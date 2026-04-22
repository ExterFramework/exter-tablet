document.addEventListener("DOMContentLoaded", function () {
  window.addEventListener("message", function (event) {
    // Verifica se a mensagem recebida é do tipo esperado
    if (event.data.type === "showTabletUI") {
      document.body.style.display = "block";
      $("LaptopContainer")
        .show()
        .css({ bottom: "-200%" })
        .animate({ bottom: "0%", top: "0%" }, 800, function () {});

      setBackground("BackG", event.data.bG, "#4169e2");
      updateTimeAndDate();
      
      const items = document.querySelectorAll(".containeritem");

      items.forEach((item) => {
        if (!item.getAttribute("data-event-added")) {
          item.addEventListener("click", handleItemClick);
          item.setAttribute("data-event-added", "true");
        }
      });
    } else if (event.data.type === "notify") {
      addNotification(event.data.title, event.data.description, event.data.imgSrc, event.data.duration);
    } else if (event.data.type === "hideTabletUI") {
      hideTabletUI();
    }
  });
  
  document.getElementById('settingsBtn').addEventListener('click', () => {
      const settingsDiv = document.getElementById('settings');
      if (settingsDiv.style.display === 'none' || settingsDiv.style.display === '') {
          settingsDiv.style.display = 'flex';
      } else {
          settingsDiv.style.display = 'none';
      }
  });

  document.querySelector('.settingssave').addEventListener('click', () => {
    const bg = document.getElementById('bgInput').value;
    const settingsDiv = document.getElementById('settings');
    settingsDiv.style.display = 'none';
  
    fetch(`https://${GetParentResourceName()}/exter-tablet:saveSettings`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ bg }),
    }).catch((error) => {
    });
  });

  function handleItemClick(event) {
    const appName = event.currentTarget.dataset.value;
    fetch(`https://${GetParentResourceName()}/openApp`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ appName }),
    }).catch((error) => {
    });
  }

  function updateTimeAndDate() {
    const cTime = document.getElementById("cTime");
    const cDate = document.getElementById("cDate");
    const now = new Date();

    const hours = now.getHours().toString().padStart(2, "0");
    const minutes = now.getMinutes().toString().padStart(2, "0");
    const timeString = `${hours}:${minutes}`;

    const day = now.getDate().toString().padStart(2, "0");
    const month = (now.getMonth() + 1).toString().padStart(2, "0"); // Months are zero-based
    const year = now.getFullYear();
    const dateString = `${month}/${day}/${year}`;

    cTime.innerHTML = timeString;
    cDate.innerHTML = dateString;
  }

  function setBackground(elementId, imageUrl, fallbackColor) {
    const element = document.getElementById(elementId);

    if (!element) {
      return;
    }

    const img = new Image();
    img.onload = function () {
      element.style.backgroundImage = `url(${imageUrl})`;
      element.style.backgroundColor = "";
    };

    img.onerror = function () {
      element.style.backgroundImage = "";
      element.style.backgroundColor = fallbackColor;
    };

    img.src = imageUrl;
  }

  function hideTabletUI() {
    var uiElement = document.body;
    uiElement.style.display = "none"; // Esconde o UI
  }

  function addNotification(title, description, imgSrc, duration) {
    const container = document.getElementById("ntfC");

    const li = document.createElement("li");
    li.className = "notificationcontainer";

    li.innerHTML = `
        <div class="_iconnotificationcontainer0">
          <img alt="" src="${imgSrc}" />
        </div>
        <div>
          <h1 class="notificationtitle">${title}</h1>
          <p class="notificationdescription">${description}</p>
        </div>
        <div>
          <svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" class="_exit_icon_14myv_20" viewBox="0 0 384 512" style="height: 1em; vertical-align: -0.125em; transform-origin: center center; overflow: visible;">
            <g transform="translate(192 256)" transform-origin="96 0">
              <g transform="translate(0,0) scale(1,1)">
                <path d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z" fill="currentColor" transform="translate(-192 -256)"></path>
              </g>
            </g>
          </svg>
        </div>
      `;

    container.appendChild(li);


    setTimeout(() => {
      container.removeChild(li);
    }, duration);

    li.querySelector("._exit_icon_14myv_20").addEventListener("click", () => {
      container.removeChild(li);
    });
  }

  document.addEventListener("keydown", function (event) {
    var keyPressed = event.key;
    switch (keyPressed) {
      case "Escape":
        var body = $("body");
        body.fadeOut(700, function () {
          $.post(`https://${GetParentResourceName()}/hideTab`);
        });
        break;
    }
  });
});
