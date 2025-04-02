/*
 * These functions below are for various webpage functionalities. 
 * Each function serves to process data on the frontend:
 *      - Before sending requests to the backend.
 *      - After receiving responses from the backend.
 * 
 * To tailor them to your specific needs,
 * adjust or expand these functions to match both your 
 *   backend endpoints 
 * and 
 *   HTML structure.
 * 
 */

import { formatFileName, showToast } from "./general.js";



// clear character display
async function clearCharacters() {
    const container = document.getElementById("characters");
    container.innerHTML = "";
}

// Fetches data from Characters table and displays it
async function fetchAndDisplayCharacters() {
    clearCharacters();
    const response = await fetch('/characters', {
        method: 'GET'
    });
    const responseData = await response.json();
    const characters = responseData.data;
    console.log(characters);

    displayCharacters(characters)
}

// Displays character data
async function displayCharacters(characters) {
    console.log(characters)
    const container = document.getElementById("characters");

    if (!characters || characters.length === 0) {
        container.innerHTML = "<p>No characters found.</p>";
        return;
    }
  
    characters.forEach(char => {
        const card = document.createElement("a");
        card.href = `character.html?name=${encodeURIComponent(char[0])}`;
        card.className = `
            group block bg-white rounded-xl shadow p-4 hover:shadow-md transition 
            hover:ring-1 hover:ring-indigo-400 cursor-pointer space-y-2
        `;

        card.innerHTML = `
            <div class="relative w-full aspect-square rounded mb-4">
                <img
                src=assets/characters/${formatFileName(char[0])}
                alt=${char[0]}
                class="w-full h-full object-cover transition-transform duration-300 ease-in-out transform group-hover:scale-110"
                />
            </div>
            <h2 class="text-lg font-semibold">${char[0]}</h2>
            <p class="text-sm text-gray-600"><strong>Element:</strong> ${char[1]}</p>
            <p class="text-sm text-gray-600"><strong>Path:</strong> ${char[3]}</p>
            <p class="text-sm text-yellow-500">${'★'.repeat(char[2])}</p>
        `;

        container.appendChild(card);
    });
}


// search functionality

async function searchCharacters() {
    const searches = [];
    const searchRows = document.querySelectorAll(".filter-row");
    let allValuesEntered = true; 

    searchRows.forEach((row) => {
        const attribute = row.querySelector(".attribute").value;
        const value = row.querySelector(".value").value.trim();
        const conjunction = row.querySelector(".conjunction")?.value || "";

        if (!value) { 
            allValuesEntered = false; 
        } else {
            searches.push({ attribute, value, conjunction });
        }
    });

    if (!allValuesEntered) {
        // alert("Please enter all values.");
        showToast("Please enter all values.", "error");
        return;
    }

    console.log(searches)
    console.log(JSON.stringify({ searches }))
    
    const response = await fetch('/characters/:search', {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ searches })
    })

    const responseData = await response.json();
    console.log(responseData);


    // Display results in the UI
    clearCharacters();
    displayCharacters(responseData.data);
}

function addFilter() {
    const filterContainer = document.getElementById("filters");
    const filterRow = document.createElement("div");

    filterRow.innerHTML = `
      <div class="filter-row flex items-center space-x-4">
        <select class="conjunction border px-3 py-2 rounded">
            <option value="AND">AND</option>
            <option value="OR">OR</option>
        </select>

        <select class="attribute border px-3 py-2 rounded">
            <option value="name">Name</option>
            <option value="element">Element</option>
            <option value="rarity">Rarity</option>
            <option value="path">Path</option>
        </select>
        
        <p class="text-gray-500">=</p>
        
        <input type="text" class="value border px-3 py-2 rounded w-1/2" placeholder="Enter value" />
        <button class="remove-filter text-gray-500 px-1 py-2 rounded">x</button>
      </div>
    `;

    const removeButton = filterRow.querySelector(".remove-filter");
    removeButton.addEventListener("click", () => {
        filterRow.remove(); // Remove the row when the button is clicked
    });
    
    filterContainer.appendChild(filterRow);
}

async function clearFilters() {
    fetchAndDisplayCharacters();

    const filterContainer = document.getElementById("filters"); 
    filterContainer.innerHTML = `
    <div class="filter-row flex items-center space-x-4">
          <select class="attribute border px-3 py-2 rounded">
              <option value="name">Name</option>
              <option value="element">Element</option>
              <option value="rarity">Rarity</option>
              <option value="path">Path</option>
          </select>

          <p class="text-gray-500">=</p>

          <input type="text" class="value border px-3 py-2 rounded w-1/2" placeholder="Enter value" />

      </div>
    `
}

// ---------------------------------------------------------------
// Initializes the webpage functionalities.
// Add or remove event listeners based on the desired functionalities.
window.onload = function() {
    fetchTableData();
    document.getElementById("add-filters").addEventListener("click", addFilter);
    document.getElementById("clear-filters").addEventListener("click", clearFilters);
    document.getElementById("search-characters").addEventListener("click", searchCharacters);
};

// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
function fetchTableData() {
    fetchAndDisplayCharacters();
}
