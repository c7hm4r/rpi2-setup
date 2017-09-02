# Automatic update role

This role configure automatic update of DPKG packages.

## Requirements

- As a user, I want to have a secure system.
    - So (security) updates shall be installed preferably early.
- As a user, I do not want to be interrupted by automatic restarts, especially when I am logged in to the system and have some “unsaved” changes.
    - So it should be check if a user is logged in some service which can cause data loss once shut down.
        - Probably SSH should be checked.
            - Then the pi must no stay always lo
    - Also the system should only be restarted when necessary and then at 03:00.
- As a user I want to get fixes for this repository automatically.
