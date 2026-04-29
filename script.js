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
