import { formatFileName } from "./general.js";

const fieldNames = {
  "BUILD_COUNT": "Number of Builds",
  "SINGLE_TARGET_COUNT": "Number of Single Target Skills",
  "HP": "HP",
};

document.addEventListener("DOMContentLoaded", () => {
  document.getElementById("runBuildCount").addEventListener("click", () =>
    runInsight("/insights/build_count", "Build Count per Character", "BUILD_COUNT", "result-build-count")
  );

  document.getElementById("runSingleTarget").addEventListener("click", () =>
    runInsight("/insights/single_target", "Characters That Have Builds With More Than 1 Single Target Skill", "SINGLE_TARGET_COUNT", "result-single-target")
  );

  document.getElementById("runAboveAvgHp").addEventListener("click", () =>
    runInsight("/insights/above_avg_hp", "Characters Thave Have Builds With Above Average HP", "HP", "result-above-avg-hp")
  );

  document.getElementById("runFullLightCones").addEventListener("click", () =>
    runInsight("/insights/full_lightcones", "Characters That Have Builds for Every Light Cone", "", "result-full-lightcones")
  );
});

async function runInsight(url, title, aggField, containerId) {
  const container = document.getElementById(containerId);
  container.innerHTML = `<p>Loading ${title}...</p>`;
  try {
    const res = await fetch(url);
    if (!res.ok) {
      throw new Error(`Request failed for ${title}`);
    }
    const data = await res.json();
    container.innerHTML = "";
    container.appendChild(createInsightSection(data.data, aggField));
  } catch (err) {
    container.innerHTML = `<p class="text-red-500">Error: ${err.message}</p>`;
  }
}

function createInsightSection(data, aggField) {
  const section = document.createElement("div");
  section.className = "bg-white shadow rounded-lg p-6";
  
  data.forEach(character => {
    const card = displayCharacter(character, aggField);
    section.appendChild(card);
  });
  
  return section;
}

function displayCharacter(character, aggField) {
  const card = document.createElement("div");
  card.className = "border p-4 rounded mb-4 flex space-x-4";
  
  const img = document.createElement("img");
  img.src = `assets/characters/${formatFileName(character.NAME)}`;
  img.alt = character.NAME || "Unknown";
  img.className = "w-16 h-16 rounded-full object-cover";
  
  const info = document.createElement("div");
  info.className = "flex-1";

  let innerHTML = `
    <p class="font-bold text-lg">${character.NAME || "N/A"}</p>
    <p class="text-gray-600">Element: ${character.ELEMENT || "N/A"}</p>
    <p class="text-gray-600">Path: ${character.PATH || "N/A"}</p>
  `;
  
  if (aggField !== "") {
    innerHTML += `<p class="text-gray-800 font-medium">${fieldNames[aggField]}: ${character[aggField] || "N/A"}</p>`;
  }
  
  const rarity = character.RARITY || 0;
  innerHTML += `<p class="text-sm text-yellow-500">${'★'.repeat(rarity)}</p>`;
  
  info.innerHTML = innerHTML;
  card.appendChild(img);
  card.appendChild(info);
  return card;
}