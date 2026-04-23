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
