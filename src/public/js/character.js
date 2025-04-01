function formatFileName(name) {
  return name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9\-]/g, '') + '.png';
}

const globalMaxStats = {
  HP: 1552,
  Attack: 776,
  Defense: 654,
  Speed: 115,
};

// Fetches specific Character details and displays it
async function fetchAndDisplayCharacter() {
    const urlParams = new URLSearchParams(window.location.search);
    const name = urlParams.get('name');
    document.getElementById('char-name').innerText = name;
    const imagePath = `assets/characters/${formatFileName(name)}`;

    const response = await fetch(`/characters/${encodeURIComponent(name)}`, {
        method: 'GET'
    });
    const responseData = await response.json();
    const char = responseData.data;

    if (char) {
      document.getElementById('char-path').innerText = char.details;

      const img = document.getElementById('character-image');
      img.src = imagePath;
      img.alt = name;

      const statsDiv = document.getElementById('stats');
      statsDiv.className = 'space-y-4';
      char.stats.forEach(stat => {
        const max = globalMaxStats[stat[0]];
        const percentage = (stat[1] / max) * 100;

        const statRow = document.createElement('div');
        statRow.className = 'flex items-center space-x-4 py-1';

        statRow.innerHTML = `
          <div class="w-24 font-medium text-gray-600">${stat[0]}</div>
          <div class="flex-1 bg-gray-200 rounded h-4 relative">
            <div class="absolute top-0 left-0 h-full bg-indigo-500 rounded" style="width: ${percentage}%;"></div>
          </div>
          <div class="w-12 text-right text-gray-700 font-medium">${stat[1]}</div>
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
