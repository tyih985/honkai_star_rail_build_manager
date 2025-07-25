import { showToast } from "./general.js";

async function fetchAndDisplayBuilds() {
    const response = await fetch('/builds', {
        method: 'GET'
    });
    const responseData = await response.json();
    const builds = responseData.data;

    const container = document.getElementById('builds');

    const fragment = document.createDocumentFragment();
    builds.forEach(([ bid, name, char, lc, playstyle ]) => {
        const card = renderBuildCard([ bid, name, char, lc, playstyle ]);
        fragment.appendChild(card);
    });

    container.innerHTML = '';
    container.appendChild(fragment);
    setupListeners();
}

function renderBuildCard([ bid, name, character, lightCone, playstyle ]) {
    const wrapper = document.createElement('div');
    wrapper.className = "build-card relative bg-white shadow-md rounded-lg p-6 border border-gray-200 hover:shadow-lg transition";
    wrapper.dataset.bid = bid;

    wrapper.innerHTML = `
      <div class="flex justify-between items-start mb-4">
        <div>
          <h3 class="build-title text-lg font-semibold text-gray-800">${name}</h3>
          <p class="build-char text-sm text-gray-500">
            Character: <span class="font-medium text-gray-700">${character}</span>
          </p>
          <p class="build-lightcone text-sm text-gray-500">
            Light Cone: <span class="font-medium text-gray-700">${lightCone}</span>
          </p>
          <p class="build-playstyle text-sm text-gray-500">
            Playstyle: <span class="font-medium text-gray-700">${playstyle}</span>
          </p>
        </div>
        <div class="flex space-x-2 text-gray-500">
          <button class="editBuild edit-btn hover:text-indigo-600" data-bid="${bid}">✏️</button>
          <button class="deleteBuild delete-btn hover:text-red-600" data-bid="${bid}">🗑️</button>
        </div>
      </div>
    `;

    return wrapper;
}

function setupListeners() {
    document.querySelectorAll(".deleteBuild").forEach(button => {
        button.addEventListener("click", deleteBuild);
    });
    document.querySelectorAll(".editBuild").forEach(button => {
        button.addEventListener("click", openEditModal);
    })

}

async function createNewBuild(event) {
    event.preventDefault();

    const buildName = document.getElementById("buildName").value.trim();
    const playstyle = document.getElementById("buildPlaystyle").value.trim();
    const cid = document.getElementById("buildCharacter").value;
    const cone_id = document.getElementById("buildLightCone").value;
    const relicHead = document.getElementById("relicHead").value;
    const relicHand = document.getElementById("relicHand").value;
    const relicBody = document.getElementById("relicBody").value;
    const relicFeet = document.getElementById("relicFeet").value;
    const relicLinkRope = document.getElementById("relicLinkRope").value;
    const relicPlanarSphere = document.getElementById("relicPlanarSphere").value;
    console.log(buildName, playstyle, cid, cone_id);

    if (!buildName || !playstyle || cid === 'search...' || cone_id === 'search...') {
        showToast("Please fill in all required fields.", "error");
        return;
    }

    try {
        const payload = {
            name: buildName,
            playstyle: playstyle,
            cid: cid,
            cone_id: cone_id,
            relics: {
                head: relicHead,
                hand: relicHand,
                body: relicBody,
                feet: relicFeet,
                linkRope: relicLinkRope,
                planarSphere: relicPlanarSphere
            }
        };

        const response = await fetch('/builds', {
            method: 'POST',
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload)
        });

        if (!response.ok) {
            showToast("A build with this name already exists.", "error");
            return;
        }

        showToast("Build created successfully", "success");
        document.getElementById("buildName").value = "";
        document.getElementById("buildPlaystyle").value = "";
        document.getElementById("buildCharacter").value = "search...";
        document.getElementById("buildLightCone").value = "search...";
        document.getElementById("relicHead").value = "search...";
        document.getElementById("relicHand").value = "search...";
        document.getElementById("relicBody").value = "search...";
        document.getElementById("relicFeet").value = "search...";
        document.getElementById("relicLinkRope").value = "search...";
        document.getElementById("relicPlanarSphere").value = "search...";
        closeCreateBuildModal();
        fetchTableData();
    } catch (err) {
        console.error(err);
        showToast("An unexpected error occurred. Please try again.", "error");
    }
}

async function deleteBuild(event) {
    console.log("clicked");
    const card = event.currentTarget.closest(".build-card");
    console.log(card);
    const bid = card.dataset.bid;
    try {
        const response = await fetch(`/builds/${bid}`, {
            method: 'DELETE'
        });
        if (!response.ok) {
            showToast("An unexpected error occurred. Please try again.", "error");
        }
        card.remove();
        showToast("Build deleted successfully", "success");
    } catch (err) {
        showToast("An unexpected error occurred. Please try again.", "error");
    }
}

async function updateBuild(event) {
    event.preventDefault();
    const editBuildNameInput = document.getElementById("editBuildName");
    const editBuildPlaystyleInput = document.getElementById("editBuildPlaystyle");
    const editBuildId = document.getElementById("editBuildId");
    const editBuildCharacterInput = document.getElementById("editBuildCharacter");
    const editBuildLightconeInput = document.getElementById("editBuildLightcone");
    const bid = editBuildId.value;
    const newName = editBuildNameInput.value.trim();
    const newPlaystyle = editBuildPlaystyleInput.value.trim();
    const newChar = editBuildCharacterInput.value;
    const newLightcone = editBuildLightconeInput.value;
    if (!newName) {
        // do something
    }

    try {
        const res = await fetch(`/builds/${bid}`, {
            method: "PUT",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                name: newName,
                playstyle: newPlaystyle,
                cid: newChar,
                cone_id: newLightcone
            })
        });

        if (!res.ok) {
            showToast("Build with that name already exists.", "error");
            return;
        }

        // Update name in UI
        const card = document.querySelector(`[data-bid="${bid}"]`);
        card.querySelector("h3").textContent = newName;
        card.querySelector(".build-playstyle span").textContent = newPlaystyle;
        card.querySelector(".build-char span").textContent = editBuildCharacterInput.options[editBuildCharacterInput.selectedIndex].text
        card.querySelector(".build-lightcone span").textContent = editBuildLightconeInput.options[editBuildLightconeInput.selectedIndex].text;

        showToast("Build edited successfully.", "success");
        closeEditModal();
    } catch (err) {
        showToast("Error occurred during edit.", "error");
    }
}

async function openEditModal(event) {
    const editModal = document.getElementById("editModal");
    const editBuildNameInput = document.getElementById("editBuildName");
    const editBuildPlaystyleInput = document.getElementById("editBuildPlaystyle");
    const editBuildCharacterInput = document.getElementById("editBuildCharacter");
    const editBuildLightconeInput = document.getElementById("editBuildLightcone")
    const editBuildId = document.getElementById("editBuildId");

    const card = event.target.closest(".build-card");
    const bid = card.dataset.bid;
    const currentName = card.querySelector(".build-title")?.textContent ?? "";
    const currentPlaystyle = card.querySelector(".build-playstyle span")?.textContent.trim() ?? "";
    const currentChar = card.querySelector(".build-char span")?.textContent.trim() ?? "";
    const currentLightcone = card.querySelector(".build-lightcone span")?.textContent.trim() ?? "";

    editBuildId.value = bid;
    editBuildNameInput.value = currentName;
    editBuildPlaystyleInput.value = currentPlaystyle;
    for (let i = 0; i < editBuildCharacterInput.options.length; i++) {
        console.log(editBuildCharacterInput.options[i], currentChar);
        if (editBuildCharacterInput.options[i].text === currentChar) {
          editBuildCharacterInput.selectedIndex = i;
          break;
        }
    }
    for (let i = 0; i < editBuildLightconeInput.options.length; i++) {
        if (editBuildLightconeInput.options[i].text === currentLightcone) {
          editBuildLightconeInput.selectedIndex = i;
          break;
        }
    }
    
    editModal.classList.remove("hidden");
    editBuildNameInput.focus();
}

async function closeEditModal(event) {
    const modal = document.getElementById("editModal");
    modal.classList.add("hidden");
}

async function openCreateBuildModal() {
    const modal = document.getElementById("buildModal");
    modal.classList.remove("hidden");
}

async function closeCreateBuildModal() {
    const modal = document.getElementById("buildModal");
    modal.classList.add("hidden");
}

async function windowListener(event) {
    const buildModal = document.getElementById("buildModal");
    const editModal = document.getElementById("editModal");
    if (event.target === buildModal) {
        closeCreateBuildModal();
    } else if (event.target === editModal) {
        closeEditModal();
    }
}

async function populateDropdown(endpoint, selectElementId) {
    try {
        const response = await fetch(endpoint);
        if (!response.ok) throw new Error("Error fetching data");
        const data = await response.json();
        const selectElement = document.getElementById(selectElementId);
        selectElement.innerHTML = '<option disabled selected>search...</option>';
        data.data.forEach(item => {
            const option = document.createElement("option");
            option.value = item[0];
            option.textContent = (item[1] || "");
            selectElement.appendChild(option);
        });
    } catch (error) {
        console.error(error);
    }
}

// ---------------------------------------------------------------
// Initializes the webpage functionalities.
// Add or remove event listeners based on the desired functionalities.
window.onload = function() {
    fetchTableData();
    window.addEventListener("click", windowListener);
    document.getElementById("openCreateBuildModal").addEventListener("click", openCreateBuildModal);
    document.getElementById("closeCreateBuildModal").addEventListener("click", closeCreateBuildModal);
    document.getElementById("closeEditModal").addEventListener("click", closeEditModal);
    document.getElementById("editForm").addEventListener("submit", updateBuild);
    document.getElementById("insertBuild").addEventListener("click", createNewBuild);

    populateDropdown('/builds/characters', 'buildCharacter');
    populateDropdown('/builds/lightcones', 'buildLightCone');
    populateDropdown('/relics/type/Head', 'relicHead');
    populateDropdown('/relics/type/Hand', 'relicHand');
    populateDropdown('/relics/type/Body', 'relicBody');
    populateDropdown('/relics/type/Feet', 'relicFeet');
    populateDropdown('/relics/type/Link%20Rope', 'relicLinkRope');
    populateDropdown('/relics/type/Planar%20Sphere', 'relicPlanarSphere');
    populateDropdown('/builds/characters', 'editBuildCharacter');
    populateDropdown('/builds/lightcones', 'editBuildLightcone');
};


// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
function fetchTableData() {
    fetchAndDisplayBuilds();
}