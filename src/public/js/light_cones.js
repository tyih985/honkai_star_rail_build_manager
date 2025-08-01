import { formatFileName } from "./general.js";

async function fetchAndDisplayLightCones() {
    const displaySection = document.getElementById("light-cones");
    const selectedAttributes = Array.from(document.querySelectorAll('.attribute-toggle:checked')).map(cb => cb.value);
    displaySection.innerHTML = ""; 
    console.log(selectedAttributes);
    let lightCones = [];
    let columns = "";

    if (!selectedAttributes.includes("name")) {
        columns += "name";
        if (selectedAttributes.length > 0) columns += ", ";
    }
    columns += selectedAttributes.join(", ");
    
    const response = await fetch(`/lightcones?columns=${columns}`, {
        method: 'GET'
    });
    const responseData = await response.json();
    lightCones = formatLightCones(responseData.data, columns.split(", "));
    
    console.log(lightCones);
  
    lightCones.forEach(lc => {
      const card = document.createElement("div");
      card.className = `
        group block bg-white rounded-xl shadow p-4 hover:shadow-md transition space-y-2
      `;
  
      let innerHTML = `
        <div class="relative w-full aspect-square rounded mb-4">
        <img
            src="assets/light_cones/${formatFileName(lc.name)}"
            alt="${lc.name}"
            class="w-full h-full object-contain transition-transform duration-300 ease-in-out transform group-hover:scale-110"
        />
        </div>
      `;
  
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

function formatLightCones(lightCones, columns) {
    return lightCones.map(row => {
      return columns.reduce((obj, col, index) => {
        obj[col] = row[index];
        return obj;
      }, {});
    });
  }
  

window.onload = function () {
    fetchAndDisplayLightCones();
    document.querySelectorAll(".attribute-toggle").forEach(cb => {
        cb.addEventListener("change", fetchAndDisplayLightCones);
    });
}