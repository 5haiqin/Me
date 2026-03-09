const fs = require('fs');

const content = fs.readFileSync('index.html', 'utf8');

let delimiter = "    <!--============================\n";
if (!content.includes(delimiter)) {
    delimiter = "    <!--============================\r\n";
}

const parts = content.split(delimiter);

const [head, nav, hero, project, skills, experience, achievements, about, education, contact] = parts;

const new_content = [
    head,
    nav,
    hero,
    about,
    education,
    skills,
    project,
    achievements,
    experience,
    contact
].join(delimiter);

fs.writeFileSync('index.html', new_content, 'utf8');
console.log('Reordered successfully!');
