// Fetches light cones data and displays it
async function fetchAndDisplayLightCones() {
  try {
    const response = await fetch('/lightcones', { method: 'GET' });
    const responseData = await response.json();
    const lightCones = responseData.data;
    const container = document.getElementById('lightcones');
    
    container.innerHTML = '';

    lightCones.forEach(lightCone => {
      const [name, rarity, path] = lightCone;

      const card = document.createElement('div');
      card.className = `
        bg-white rounded-xl shadow p-4 hover:shadow-md transition 
        cursor-default space-y-2
      `;
      
      card.innerHTML = `
        <div class="w-full aspect-square bg-gray-200 rounded mb-2"></div>
        <h2 class="text-lg font-semibold">${name}</h2>
        <p class="text-sm text-gray-600"><strong>Path:</strong> ${path}</p>
        <p class="text-sm text-yellow-500">${'★'.repeat(rarity)}</p>
      `;
      
      container.appendChild(card);
    });
  } catch (err) {
    console.error("Error fetching light cones:", err);
  }
}

// Initialize light cones display on window load
window.onload = function() {
  fetchAndDisplayLightCones();
};
