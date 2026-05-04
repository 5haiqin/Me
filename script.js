/**
 * "Me" Portfolio Scripts
 * Contains shared logic for DOM manipulation and animations.
 */

document.addEventListener('DOMContentLoaded', () => {
    // Select ALL slider containers to fix looping on every section
    const sliderContainers = document.querySelectorAll(".slider__container");

    sliderContainers.forEach((container, index) => {
        const track = container.querySelector(".slider__track");
        if (track) {
            // Clone the slider track multiple times to create a seamless infinite scrolling effect
            // We use 4 clones to ensure even on ultrawide screens it never runs out of content
            const clones = [
                track.cloneNode(true),
                track.cloneNode(true),
                track.cloneNode(true),
                track.cloneNode(true)
            ];
            
            // Alternate the animation direction for every second section
            if (index % 2 === 0) {
                track.classList.add('slider__track--reverse');
                clones.forEach(clone => clone.classList.add('slider__track--reverse'));
            }
            
            // Append the cloned nodes to ensure continuous ticker animation
            clones.forEach(clone => container.appendChild(clone));
        }
    });

    // Cyber Hero Marquee
    const cyberMarquee = document.getElementById('cyber-marquee');
    
    if (cyberMarquee) {
        const clone1 = cyberMarquee.innerHTML;
        cyberMarquee.innerHTML += clone1 + clone1 + clone1;

        cyberMarquee.animate(
            [
                { transform: 'translateX(0)' },
                { transform: 'translateX(-50%)' }
            ],
            {
                duration: 20000, // 20 seconds for a full loop
                iterations: Infinity,
                easing: 'linear'
            }
        );
    }

    // Mobile Project Scroll Observer
    const viewAllBtn = document.getElementById('mobile-view-all');
    const projectCards = document.querySelectorAll('.project-card');
    
    if (viewAllBtn && projectCards.length >= 4) {
        const fourthCard = projectCards[3]; // 0-indexed, so 3 is the 4th card
        
        const observer = new IntersectionObserver((entries) => {
            if (window.innerWidth <= 1000) {
                if (entries[0].isIntersecting) {
                    // Reached the 4th card
                    viewAllBtn.innerHTML = '<span>#</span>View all&lt;<span>~</span>&gt;';
                } else {
                    // Not at the end, prompt to swipe
                    viewAllBtn.innerHTML = '<span>#</span>View all<span>~</span>&gt;';
                }
            }
        }, {
            threshold: 0.5 // Trigger when 50% of the 4th card is visible
        });
        
        observer.observe(fourthCard);
        
        // Handle window resize to reset text if moving from mobile to desktop
        window.addEventListener('resize', () => {
            if (window.innerWidth > 1000) {
                viewAllBtn.innerHTML = '<span>#</span>View all&lt;<span>~</span>&gt;';
            }
        });
        
        // Trigger initial check in case page loads on mobile size
        if (window.innerWidth <= 1000 && !fourthCard.getBoundingClientRect().width) {
             // Fallback if not intersecting on load
             viewAllBtn.innerHTML = '<span>#</span>View all<span>~</span>&gt;';
