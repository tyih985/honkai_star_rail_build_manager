async function fetchAndDisplayBuilds() {
    const response = await fetch('/builds', {
        method: 'GET'
    });
    const responseData = await response.json();
    const builds = responseData.data
}

async function openModal() {
    const modal = document.getElementById("buildModal");
    modal.classList.remove("hidden");
}

async function closeModal() {
    const modal = document.getElementById("buildModal");
    modal.classList.add("hidden");
}

async function windowListener(event) {
    const modal = document.getElementById("buildModal");
    const modalContent = document.getElementById('modalContent');
    if (event.target === modal) {
        closeModal();
    }
}

// ---------------------------------------------------------------
// Initializes the webpage functionalities.
// Add or remove event listeners based on the desired functionalities.
window.onload = function() {
    // fetchTableData();
    window.addEventListener("click", windowListener);
    document.getElementById("openModal").addEventListener("click", openModal);
    document.getElementById("closeModal").addEventListener("click", closeModal);
    document.getElementById("insertBuild").addEventListener("submit", )
    // document.getElementById("resetDemotable").addEventListener("click", resetDemotable);
    // document.getElementById("insertDemotable").addEventListener("submit", insertDemotable);
    // document.getElementById("updataNameDemotable").addEventListener("submit", updateNameDemotable);
    // document.getElementById("countDemotable").addEventListener("click", countDemotable);
};


// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
function fetchTableData() {
}
