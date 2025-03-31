async function renderCards() {
    const displaySection = document.getElementById("light-cones");
    const selectedAttributes = Array.from(document.querySelectorAll('.attribute-toggle:checked')).map(cb => cb.value);
    displaySection.innerHTML = ""; 

    const response = await fetch("/lightcones", {
        method: 'GET'
    });
    const responseData = await response.json();
    const lightCones = formatLightCones(responseData.data);
  
    lightCones.forEach(lc => {
      const card = document.createElement("div");
      card.className = `
        block bg-white rounded-xl shadow p-4 hover:shadow-md transition space-y-2
      `;
  
      let innerHTML = '';
  
      selectedAttributes.forEach(attr => {
        if (attr === "name") {
            innerHTML += `<h2 class="text-lg font-semibold">${lc.name}</h2>`;
        }
        if (attr === "rarity") {
          innerHTML += `<p class="text-sm text-yellow-500">${'★'.repeat(lc.rarity)}</p>`;
        } else if (attr !== "name" && lc[attr]) {
          innerHTML += `
            <p class="text-sm text-gray-600">
              <strong class="capitalize">${attr}:</strong> ${lc[attr]}
            </p>`;
        }
      });
  
      card.innerHTML = innerHTML;
      displaySection.appendChild(card);
    });
}

function formatLightCones(lightCones) {
    const formatted = lightCones.map(([name, rarity, path, description]) => ({
        name,
        rarity,
        path,
        description
    }));
    return formatted;
}


window.onload = function () {
    renderCards();
    document.querySelectorAll(".attribute-toggle").forEach(cb => {
        cb.addEventListener("change", renderCards);
    });
}