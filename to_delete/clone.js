const fs = require('fs');

const content = fs.readFileSync('index.html', 'utf8');

let delimiter = "    <!--============================\n";
if (!content.includes(delimiter)) {
    delimiter = "    <!--============================\r\n";
}

const parts = content.split(delimiter);

const head = parts[0];
const nav = parts[1];
const hero = parts[2];
const about = parts[3];
const education = parts[4];
const contactPart = parts[9];

let footerContent = "";
const footerIndex = contactPart.indexOf('</section>');
if (footerIndex !== -1) {
    footerContent = contactPart.substring(footerIndex + '</section>'.length);
} else {
    // fallback
    footerContent = "\n    <footer class=\"footer\">\n        <p class=\"footer__text\">\n            © Copyright 2024. Made by Shaiqin\n        </p>\n    </footer>\n</body>\n</html>";
}

const new_content = [
    head,
    nav,
    hero,
    about,
    education
].join(delimiter) + footerContent;

fs.writeFileSync('try3.html', new_content, 'utf8');
console.log('try3.html created successfully!');
