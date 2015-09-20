# Architecture

## Communities, Gatherings, and Members

Gatherings builds on two core concepts: Communities and Gatherings. Gatherings always belong to one
Community. Communities may be affiliated with one another, either through a parent Community or
directly.

Members attend Gatherings, however, they do not belong to a Gathering but to the Community to which
the Gathering itself belongs. Members may belong to multiple Gatherings and to multiple Communities.
Membership, in this sense, is not ownership, but an affiliation. To participate in a Gathering, a
Member must affiliate with a Community.

Members register with TheGatherings and then affiliate with a Community (through joining a 
Gathering -- see below).

## Identity, Access, and Authorization

Member identity is an OAuth2 token. For Members who lack or are not willing to login via a supported
OAuth2 provider (e.g., Facebook, Google), TheGatherings will provide an OAuth2 provider with which the
Member must register. Either way, once registered, a Member will have an account (fed from their
OAuth provider).

Members (like all other elements) are never deleted. They can Leave a Community and / or Gathering.
When leaving, they may opt to be Remembered. Remembered Members can re-join without an Invitation.
Members who have left will require a new Invitation (and are, for all intents and purposes, new
Members).

Members have access to their Communities and its Gatherings. A Member must authorize each Community.

Authorization uses a simple model: Members have one of three Roles -- Leader, Assistant, or
Participant -- within Scopes -- Communities and Gatherings are scopes. The Role defines the rights
within the scope. Community Leaders, for example, have full rights to the Community and to its
Gatherings. Gathering Leaders have full rights to that Gatherings. Finer grained authorization would
increase complexity without adding clear benefits.

## Invitations and Joining a Gathering

Members need an Invitation to join a Gathering. Leaders and Assistants, of both Communities and
Gatherings, may send Invitations.  If the Member is already affiliated with the Community the
Invitation validates their desire to to join. If they are not yet a Member, they are first asked to
affiliate. After affiliating, they will be sent to the same "page" as that given to the affiliated
Member (i.e., validating that they want to join).

Invitations have a lifespan (usually one week, though it may be set by the Community Leader)
and are single use. *For new Members, we'll need some means of validating that the intended person
is accepting the Invitation.*

## Discussions, Opportunities, Resources, and Tags

Beyond the core elements of Communities, Gatherings, and Members, TheGatherings will include
several other key items:

- Opportunities: Collections of service opportunities, scoped to a Community
- Resources: A loose collection of things useful to Gatherings, scoped to a TheGatherings
- Tags: A free-form (that is, without a taxonomy) collection of terms used to describe Gatherings,
Opportunities, and Resources
- Discussions: Moderated dicussions associated with a Gathering, Opportunity, or Resource

## Data Management

Data in TheGatherings divides into three clumps: A Community and its Gatherings, Members, and
Resources. Each is the unit of scale. As a result, Communities and Gatherings "know" Members by
their external identifier. Similarly, a Member "knows" their Communities and Gatherings through
their external identifiers.

External identifiers are paths. A Community, when created, obtains a unique path name (derived
from its public name -- though the Administrator may choose another unique string). The path for a
Gathering begins with its Community's path followed by a path name, unique only within the 
owning Community, derived from its name (or selected by the Gathering Leader). Once created, paths
cannot change.

No data is ever deleted or updated. All Community, Gathering, and Member records contain, at least,
two timestamps: active_on and inactive_on. Deleting a record sets the "inactive on" timestamp.

All timestamps are UTC ISO8601 UTC text strings (i.e., YYYY-MM-DDTHH:MM:SSZ).
