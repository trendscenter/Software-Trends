# Local Matlab Software

**Last Updated:** 2026-05-18  
**Maintainer:** Cyrus Eierud, TReNDS Center

This folder contains standalone/local Python applications that can be installed and executed on personal computers, laptops, or local workstations.

---

# General Structure

Each application should have its own dedicated subfolder under this directory.

Example:

```text
local/
└── matlab/
     └── MyApplication
         ├── README.md
         └── docs/
             └── web/
                 ├── README.md
                 └── images/
```

**Instructions for Adding a New Application**

1. Create a new folder using your application name.
Example: MyApplication/

2. Inside your application folder, add a README.md file containing:
- A short description of the application
- Installation instructions
- Usage examples
- Dependencies or requirements
- Contact or maintainer information
- Links to additional web-based documentation (if available)
3. Create a docs folder inside your application folder.
4. Inside the docs folder, create a web folder.
5. Inside the web folder, add a README.md file that serves as the main user documentation page.
6. Inside the web folder, create an images folder for screenshots, figures, diagrams, and other documentation assets.

Images may be referenced in Markdown using standard Markdown image syntax:

```text
![Example Image](images/example.png)
```
**Recommended Documentation Content**

The docs/web/README.md documentation page should ideally include:

- Overview
- Features
- Installation
- Quick Start Guide
- Configuration
- Example Workflows
- Screenshots
- Troubleshooting
- Citation Information (if applicable)
- License Information

**Notes**
- Keep documentation updated as the software evolves.
- Use clear folder and file naming conventions.
- Prefer Markdown formatting for portability and GitHub compatibility.
- Include screenshots or example outputs whenever helpful.

**Questions**
For questions regarding repository organization or documentation standards, please contact the TReNDS development team.
