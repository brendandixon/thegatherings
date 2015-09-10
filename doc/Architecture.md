# Architecture

## Communities, Gatherings, and Members

Gatherings builds on two core concepts: Communities and Gatherings. Gatherings always belong to one
Community. Communities may be affiliated with one another, either through a parent Community or
directly.

Members attend Gatherings, however, they do not belong to a Gathering but to the Community to which
the Gathering itself belongs. Members may belong to multiple Gatherings and to multiple Communities.
Membership, in this sense, is not ownership, but an affiliation. To participate in a Gathering, a
Member must affiliate with a Community.

## Identity, Access, and Authorization

Member identity is an OAuth2 token. For Members who lack or are not willing to login via a supported
OAuth2 provider (e.g., Facebook, Google), Gatherings will provide an OAuth2 provider with which the
Member must register. Either way, once affiliated with a Community, the Member will be able to set
contact information and so forth (which will override that retrieved from an OAuth2 provider).

Members (like all other elements) are never deleted. They can Leave a Community and / or Gathering.
When leaving, they may opt to be Remembered. Remembered Members can re-join without an Inviation.
Members who have left will require a new Invitation (and are, for all intents and purposes, new
Members).

Members have access to their Communities and its Gatherings. A Member must authorize each Community.
Communities do not share Members. However, Gatherings will support sharing Member information (other
than the OAuth2 token) between affiliated Communities, subject to Member approval.

Authorization uses a simple model: Members have one of three Roles -- Leader, Assistant, or
Participant -- within Scopes -- Communities and Gatherings are scopes. The Role defines the rights
within the scope. Community Leaders, for example, have full rights to the Community and to its
Gatherings. Gathering Leaders have full rights to that Gatherings. Finer grained authorization would
increase complexity without adding clear benefits.

## Joining a Gathering

Members need an Invitation to join a Gathering. Leaders and Assistants, of both Communities and
Gatherings, may send Invitations.  If the Member is already affiliated with the Community the
Invitation validates their desire to to join. If they are not yet a Member, they are first asked to
affiliate. After affiliating, they will be sent to the same "page" as that given to the affiliated
Member (i.e., validating that they want to join).

Invitations have a lifespan (usually one week, though it may be set by the Community Leader)
and are single use. *For new Members, we'll need some means of validating that the intended person
is accepting the Invitation.*

## Data Management

All data is scoped to a Community. Communities affiliate by sharing their external, public URLs, and
not internal pointers. Gatherings reside with their Community, making the Community the unit of
scale.

No data is ever deleted or updated. All records contain, at least, two timestamps: active_on and
inactive_on. Deleting a record sets the "inactive on" timestamp. An Update is a elete and Create.

All timestamps are UTC ISO8601 text strings (i.e., YYYY-MM-DDTHH:MM:SSZ).
