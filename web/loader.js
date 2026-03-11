// Custom loader script for Aman Kumar Portfolio
const messages = [
    'Calibrating systems for launch',
    'Deploying resources',
    'Initiating sequence, please wait'
];

const randomMessage = messages[Math.floor(Math.random() * messages.length)];
document.getElementById('loading-text').textContent = randomMessage;

window.addEventListener('flutter-first-frame', function() {
    const loader = document.getElementById('loading-container');
    loader.classList.add('fade-out');
    setTimeout(function() {
        loader.style.display = 'none';
    }, 400);
});
