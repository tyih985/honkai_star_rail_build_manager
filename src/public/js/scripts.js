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


// This function checks the database connection and updates its status on the frontend.
async function checkDbConnection() {
    const statusElem = document.getElementById('dbStatus');
    const loadingGifElem = document.getElementById('loadingGif');

    const response = await fetch('/check-db-connection', {
        method: "GET"
    });

    // Hide the loading GIF once the response is received.
    loadingGifElem.style.display = 'none';
    // Display the statusElem's text in the placeholder.
    statusElem.style.display = 'inline';

    response.text()
    .then((text) => {
        statusElem.textContent = text;
    })
    .catch((error) => {
        statusElem.textContent = 'connection timed out';  // Adjust error handling if required.
    });
}

// Fetches data from the demotable and displays it.
async function fetchAndDisplayUsers() {
    const tableElement = document.getElementById('demotable');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/demotable', {
        method: 'GET'
    });

    const responseData = await response.json();
    const demotableContent = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    demotableContent.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

// This function resets or initializes the demotable.
async function resetDemotable() {
    const response = await fetch("/initiate-demotable", {
        method: 'POST'
    });
    const responseData = await response.json();

    if (responseData.success) {
        const messageElement = document.getElementById('resetResultMsg');
        messageElement.textContent = "demotable initiated successfully!";
        fetchTableData();
    } else {
        alert("Error initiating table!");
    }
}

// Inserts new records into the demotable.
async function insertDemotable(event) {
    event.preventDefault();

    const idValue = document.getElementById('insertId').value;
    const nameValue = document.getElementById('insertName').value;

    const response = await fetch('/insert-demotable', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            id: idValue,
            name: nameValue
        })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('insertResultMsg');

    if (responseData.success) {
        messageElement.textContent = "Data inserted successfully!";
        fetchTableData();
    } else {
        messageElement.textContent = "Error inserting data!";
    }
}

// Updates names in the demotable.
async function updateNameDemotable(event) {
    event.preventDefault();

    const oldNameValue = document.getElementById('updateOldName').value;
    const newNameValue = document.getElementById('updateNewName').value;

    const response = await fetch('/update-name-demotable', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            oldName: oldNameValue,
            newName: newNameValue
        })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('updateNameResultMsg');

    if (responseData.success) {
        messageElement.textContent = "Name updated successfully!";
        fetchTableData();
    } else {
        messageElement.textContent = "Error updating name!";
    }
}

// Counts rows in the demotable.
// Modify the function accordingly if using different aggregate functions or procedures.
async function countDemotable() {
    const response = await fetch("/count-demotable", {
        method: 'GET'
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('countResultMsg');

    if (responseData.success) {
        const tupleCount = responseData.count;
        messageElement.textContent = `The number of tuples in demotable: ${tupleCount}`;
    } else {
        alert("Error in count demotable!");
    }
}

// Converts character name to image file name
function formatFileName(name) {
    return name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9\-]/g, '') + '.png';
}



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
    allValuesEntered = true; 

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
        alert("Please enter all values.");
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
    checkDbConnection();
    fetchTableData();
    // document.getElementById("resetDemotable").addEventListener("click", resetDemotable);
    // document.getElementById("insertDemotable").addEventListener("submit", insertDemotable);
    // document.getElementById("updataNameDemotable").addEventListener("submit", updateNameDemotable);
    // document.getElementById("countDemotable").addEventListener("click", countDemotable);
};

// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
function fetchTableData() {
    fetchAndDisplayCharacters();
}
