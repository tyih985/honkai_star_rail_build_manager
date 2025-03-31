// Fetches relics data and displays it
async function fetchAndDisplayRelics() {
  try {
    const response = await fetch('/relics', { method: 'GET' });
    const responseData = await response.json();
    const relics = responseData.data;
    const container = document.getElementById('relics');
    
    container.innerHTML = '';

    relics.forEach(relic => {
      // Destructure: [name, setName, rarity]
      const [name, setName, rarity] = relic;

      const card = document.createElement('div');
      card.className = `
        bg-white rounded-xl shadow p-4 hover:shadow-md transition 
        cursor-default space-y-2
      `;
      
      card.innerHTML = `
        <h2 class="text-lg font-semibold">${name}</h2>
        <p class="text-sm text-gray-600"><strong>Set:</strong> ${setName}</p>
        <p class="text-sm text-yellow-500">${'★'.repeat(rarity)}</p>
      `;
      
      container.appendChild(card);
    });
  } catch (err) {
    console.error("Error fetching relics:", err);
  }
}

// Initialize relics display on window load
window.onload = function() {
  fetchAndDisplayRelics();
};