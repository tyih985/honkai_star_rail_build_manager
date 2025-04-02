export function showToast(message, type = 'success') {
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

export function formatFileName(name) {
    if (!name) return "default.png";
    return name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9\-]/g, '') + '.png';
  }