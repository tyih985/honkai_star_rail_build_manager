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
    wrapper.dataset.bid = bid; // ✅ make sure it's on the wrapper
  
    wrapper.innerHTML = `
      <div class="flex justify-between items-start mb-4">
        <div>
          <h3 class="build-title text-lg font-semibold text-gray-800">${name}</h3>
          <p class="text-sm text-gray-500">
            Character: <span class="font-medium text-gray-700">${character}</span>
          </p>
          <p class="text-sm text-gray-500">
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

async function updateBuildName(event) {
    event.preventDefault();
    const editBuildNameInput = document.getElementById("editBuildName");
    const editBuildPlaystyleInput = document.getElementById("editBuildPlaystyle");
    const editBuildId = document.getElementById("editBuildId");
    const bid = editBuildId.value;
    const newName = editBuildNameInput.value.trim();
    const newPlaystyle = editBuildPlaystyleInput.value.trim();
    if (!newName) {
        // do something
    }

    try {
        const res = await fetch(`/builds/${bid}`, {
            method: "PUT",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ 
              name: newName,
              playstyle: newPlaystyle
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

        showToast("Build renamed successfully.", "success");
        closeEditModal();
    } catch (err) {
        showToast("Error occurred during rename.", "error");
    }
}

async function openEditModal(event) {
    const editModal = document.getElementById("editModal");
    const editBuildNameInput = document.getElementById("editBuildName");
    const editBuildPlaystyleInput = document.getElementById("editBuildPlaystyle");
    const editBuildId = document.getElementById("editBuildId");

    const card = event.target.closest(".build-card");
    const bid = card.dataset.bid;
    const currentName = card.querySelector(".build-title")?.textContent ?? "";
    const currentPlaystyle = card.querySelector(".build-playstyle span")?.textContent.trim() ?? "";

    editBuildId.value = bid;
    editBuildNameInput.value = currentName;
    editBuildPlaystyleInput.value = currentPlaystyle;

    editModal.classList.remove("hidden");
    editBuildNameInput.focus();
}

async function closeEditModal() {
    const modal = document.getElementById("editModal");
    editModal.classList.add("hidden");
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

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
  
    const iconMap = {
      success: '✅',
      error: '❌'
    };
  
    const borderMap = {
      success: 'border-green-500',
      error: 'border-red-500'
    };
  
    toast.className = `
      flex items-start gap-3 w-72 p-4 pr-5 bg-white rounded-lg border-l-4 shadow-md
      ${borderMap[type] || borderMap.success}
      transform transition-all duration-500 ease-out translate-x-96 opacity-0
    `;
  
    toast.innerHTML = `
      <div class="text-xl">${iconMap[type] || '✅'}</div>
      <div class="text-sm font-medium text-gray-800">${message}</div>
    `;
  
    const container = document.getElementById('toast-container');
    container.appendChild(toast);
  
    // Trigger animation
    requestAnimationFrame(() => {
      toast.classList.remove('translate-x-96', 'opacity-0');
      toast.classList.add('translate-x-0', 'opacity-100');
    });
  
    // Auto-dismiss after 3s
    setTimeout(() => {
      toast.classList.remove('translate-x-0', 'opacity-100');
      toast.classList.add('translate-x-96', 'opacity-0');
      setTimeout(() => toast.remove(), 400); // remove after animation
    }, 3000);
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
    document.getElementById("editForm").addEventListener("submit", updateBuildName);


    // document.getElementById("insertBuild").addEventListener("submit",  )
    // document.getElementById("resetDemotable").addEventListener("click", resetDemotable);
    // document.getElementById("insertDemotable").addEventListener("submit", insertDemotable);
    // document.getElementById("updataNameDemotable").addEventListener("submit", updateNameDemotable);
    // document.getElementById("countDemotable").addEventListener("click", countDemotable);
};


// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
function fetchTableData() {
    fetchAndDisplayBuilds();
}
