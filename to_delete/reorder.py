import os

with open('index.html', 'r', encoding='utf-8') as f:
    content = f.read()

# The delimiter is exactly:
#    <!--============================
delimiter = "    <!--============================\n"
if delimiter not in content:
    delimiter = "    <!--============================\r\n"

parts = content.split(delimiter)

if len(parts) != 9:
    print(f"Error: Expected 9 parts (head + 8 sections), got {len(parts)}")
    for i, p in enumerate(parts):
        print(f"{i}: {p[:40]}")
    exit(1)

# Current Order in parts:
# 0: Head / Nav
# 1: Cyber Hero
# 2: Project
# 3: Skills
# 4: Experience
# 5: Achievements
# 6: About
# 7: Education
# 8: Contact

head = parts[0]
hero = parts[1]
project = parts[2]
skills = parts[3]
experience = parts[4]
achievements = parts[5]
about = parts[6]
education = parts[7]
contact = parts[8]

# User requested order:
# 1. Landing Page (Hero)
# 2. About Me (About)
# 3. Education
# 4. Skills
# 5. Project
# 6. Achievements
# 7. Experience
# 8. Contact

new_content = head + \
              delimiter + hero + \
              delimiter + about + \
              delimiter + education + \
              delimiter + skills + \
              delimiter + project + \
              delimiter + achievements + \
              delimiter + experience + \
              delimiter + contact

with open('index.html', 'w', encoding='utf-8') as f:
    f.write(new_content)

print("Reordered successfully!")
