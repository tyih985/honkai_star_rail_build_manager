
// Fetches specific Character details and displays it
async function fetchAndDisplayCharacter() {
    const urlParams = new URLSearchParams(window.location.search);
    const name = urlParams.get('name');
    document.getElementById('char-name').innerText = name;

    const response = await fetch(`/characters/${encodeURIComponent(name)}`, {
        method: 'GET'
    });
    const responseData = await response.json();
    const char = responseData.data;

    const db = {
      "March 7th": {
        info: { element: "Ice", rarity: 4, path: "The Preservation" },
        stats: { HP: 1058, ATK: 511, DEF: 573, SPD: 101, Taunt: 150 },
        materials: ["Oath of Steel", "Tracks of Destiny"]
      },
      "Dan Heng": {
        info: { element: "Wind", rarity: 4, path: "The Hunt" },
        stats: { HP: 902, ATK: 640, DEF: 398, SPD: 109, Taunt: 75 },
        materials: ["Squirming Core", "Sparse Aether"]
      }
    };

    if (char) {
      document.getElementById('char-path').innerText = char.details;

      const statsDiv = document.getElementById('stats');
      char.stats.forEach(([label, value]) => {
        const statRow = document.createElement('div');
        statRow.className = 'flex items-center space-x-4';
        statRow.innerHTML = `
          <div class="w-20 font-medium text-gray-600">${label}</div>
          <div class="flex-1 bg-gray-200 rounded h-3 relative">
            <div class="absolute top-0 left-0 h-full bg-indigo-500 rounded" style="width: ${Math.min(value / 12, 100)}%"></div>
          </div>
        `;
        statsDiv.appendChild(statRow);
      });

      const materialsDiv = document.getElementById('materials');
      materialsDiv.innerHTML = char.materials.map(mat => `<p class="mb-1">• ${mat}</p>`).join("");
    } else {
      document.querySelector('main').innerHTML = `
        <div class="text-center text-red-600 text-lg font-semibold">Character not found.</div>
        <div class="text-center mt-4">
          <a href="char_list.html" class="text-blue-600 hover:underline text-sm">← Back to Characters</a>
        </div>
      `;
    }
}

// ---------------------------------------------------------------
// Initializes the webpage functionalities.
// Add or remove event listeners based on the desired functionalities.
window.onload = function() {
    fetchTableData();
};

// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
function fetchTableData() {
    fetchAndDisplayCharacter();
}
