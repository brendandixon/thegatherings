# Roles

Each major object defines a scope that includes the object itself, such as the Community, and those
objects beneath it, such as the Gatherings belonging to a Community. Within each scope exist
these roles:

- Administrator: Administrators have full rights to all objects with their scope
- Leader: Leaders have all the rights of a Leader *except* the ability to assign Leaders and
Administrators.
- Coach: Coaches provide an oversight role
- Assistants: Assistants have varying, limited rights, within the scope

Additionally, Members may be a *Participant* within a scope (such as a Gathering). While not
strictly a role, Participants generally have Read rights within the scope. They also have the Delete
right for their association with objects in the scope.

Each section below precisely defines the rights Members in role have within the scope.

## Community Roles

- Administrator: Administrators have full CRUD access to the Community along with its associated
Campuses and Gatherings. Administrators also have Read rights to all Members within their scope.
Administrators may also create new Members (associated, by default, with their Community).

- Leader: Leaders have all the rights of Administrators except that they cannot assign Members to
the Leader or Administrator roles.

- Coach: Coaches can create new Members and may associated Members with *any* Gathering within the
scope. Further, they may choose to become the Coach of *any* Gathering within the scope.

- Assistant: Assistants have Update rights to the Community, its Campuses, and Gatherings. They may
create new Members associated with the Community.

- Participant: Participants have Read rights to the Community and its Campuses. They have limited
Read rights to Gatherings within the scope (e.g., they can see the description, but not the active
Members). Participants may create new Gatherings becoming, by default, the Leader of the
Gathering.

## Campus Roles

The roles applied within a Campus function the same as at the Community, except limiting the scope
to the Campus and the Gatherings associated with the Campus.

## Gathering Roles

- Leader: Leaders have full CRUD rights to the Gathering.

- Coach: Coaches have full Read rights, but are not considered part of the Gathering. They may
participate in conversations, post messages, and so forth.

- Assistant: Assistants have Create (to accept new Members), Read, and Update rights to the
Gathering.

- Participant: Participants have full Read access to the Gathering. They have limited Create
rights (e.g., they may post messages, participate in conversations). They can choose to leave
the Gathering (Delete rights to their affiliation).
