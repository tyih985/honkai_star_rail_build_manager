document.getElementById("runAggregates").addEventListener("click", runAggregates);

async function runAggregates() {
  const resultsContainer = document.getElementById("results");
  resultsContainer.innerHTML = "<p>Loading...</p>";
  try {
    const buildCount = await fetchAggregate("/aggregates/build_count");
    const singleTarget = await fetchAggregate("/aggregates/single_target");
    const aboveAvgHp = await fetchAggregate("/aggregates/above_avg_hp");
    const fullLightCones = await fetchAggregate("/aggregates/full_lightcones");

    resultsContainer.innerHTML = `
      <h2 class="text-xl font-bold">Build Count per Character</h2>
      <pre>${JSON.stringify(buildCount.data, null, 2)}</pre>
      
      <h2 class="text-xl font-bold">Characters with >1 Single Target Ability</h2>
      <pre>${JSON.stringify(singleTarget.data, null, 2)}</pre>
      
      <h2 class="text-xl font-bold">Characters with Above Average HP</h2>
      <pre>${JSON.stringify(aboveAvgHp.data, null, 2)}</pre>
      
      <h2 class="text-xl font-bold">Characters with Full Light Cone Coverage</h2>
      <pre>${JSON.stringify(fullLightCones.data, null, 2)}</pre>
    `;
  } catch (err) {
    resultsContainer.innerHTML = `<p class="text-red-500">Error: ${err.message}</p>`;
  }
}

async function fetchAggregate(endpoint) {
  const res = await fetch(endpoint);
  if (!res.ok) throw new Error(`Failed to fetch ${endpoint}`);
  return await res.json();
}