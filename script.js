// --- Color Slider Logic ---
const hueSlider = document.getElementById('hueSlider');
if (hueSlider) {
    const savedHue = localStorage.getItem('headerHue');
    if (savedHue !== null) {
        hueSlider.value = savedHue;
        document.documentElement.style.setProperty('--main-hue', savedHue);
    }
    hueSlider.addEventListener('input', (e) => {
        const hueValue = e.target.value;
        document.documentElement.style.setProperty('--main-hue', hueValue);
        localStorage.setItem('headerHue', hueValue);
    });
}

// --- Smooth Scroll for Anchor Links ---
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) target.scrollIntoView({ behavior: 'smooth' });
    });
});

// --- Active Link Highlighting ---
const sections = document.querySelectorAll('section');
const navLinks = document.querySelectorAll('.sidebar-menu .nav-link');
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === `#${entry.target.id}`) {
                    link.classList.add('active');
                }
            });
        }
    });
}, { root: document.querySelector('.content'), rootMargin: '-10% 0px -80% 0px' });

sections.forEach(section => observer.observe(section));



// Reusable function to load HTML
function loadHTML(fileName, elementId) {
  fetch(fileName)
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.text();
    })
    .then(data => {
      document.getElementById(elementId).innerHTML = data;
    })
    .catch(error => {
      console.error(`Error loading ${fileName}:`, error);
      document.getElementById(elementId).innerHTML = 'Failed to load content.';
    });
}

// Call the function for each file you want to load
loadHTML('optifine-forge.html', 'content-one');
loadHTML('optifine-McLauncher.html', 'content-two');
loadHTML('setup_server.html', 'content-three');
loadHTML('brain_teasers.html', 'content-four');
