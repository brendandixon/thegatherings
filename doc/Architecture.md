# Architecture

## Communities, Gatherings, and Members
Gatherings is built around two core concepts: Communities and Gatherings. Gatherings always belong
to one Community. Communities may be affiliated with one another, either through a parent Community
or directly.

Members represent those who attend Gatherings, however, they do not belong to a Gathering but to
the Community to which the Gathering itself belongs. Members may belong to multiple Gatherings and
to multiple Communities. Membership, in this sense, is not ownership, but an affiliation. To
participate in a Gathering, a Member must affiliate with a Community.

## Identity, Access, and Authorization
Member identity is either an OAuth2 token. For Members not willing to login via a supported OAuth2
provider (e.g., Facebook, Google), Gatherings will provide an OAuth2 provider with which the Member
must register.

Members (like all other elements) are never deleted. They can Leave a Community and / or
Gathering. When leaving, they may opt to be Remembered. Remembered Members can re-join without an
Inviation. Members who have left will require a new Invitation (and are, for all intents and
purposes, new Members).

Members have access to their Communities and its Gatherings. A Member must authorize each
Community. Communities do not share Members. However, Gatherings will support sharing
Member information (other than the OAuth2 token) between affiliated Communities, subject to Member
approval.

Members cannot join a Community uninvited, they require an invitation (to be bootstrapped by the
Community administrator). Inviting new Members is an authorization scope generally associated with
Leaders, but may be applied to other Members as well.

Communities and Gatherings are scopes and have scopes. For example, both will have an Invite scope
to limit who can invite new Members. Similarly, both will have an Information scope that controls
who can see and change the details. CRUD will determine rights within a scope; the meaning of each
action is scope determined.

## Data Management
All data is scoped to a Community. Communities affiliate by sharing their external, public URLs, and
not internal pointers. Gatherings reside with their Community, making the Community the unit of
scale.

No data is ever deleted or updated. All records contain, at least, two timestamps: "active on" and
"inactive on." Deleting a record sets the "inactive on" timestamp. An Update is a Delete and
Create.

All timestamps are UTC ISO8601 text strings (e.g., YYYY-MM-DDTHH:MM:SSZ).
