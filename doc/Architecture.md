# Architecture

## Communities, Gatherings, and Members

Gatherings builds on two core concepts: Communities and Gatherings. Gatherings always belong to one
Community. Communities have at least one Campus. Gatherings may be affiliated with a Campus. Even
though a Community must have at least one Campus, Campuses are not a top-level concept, such as
Gatherings or their owning Community, but an optional affiliation for a Gathering. A Member may
filter Gatherings to a particular Campus, but they do not seek for Gatherings through a Campus (in a
RESTful sense).

Members attend Gatherings, however, they do not belong to a Gathering but to the Community to which
the Gathering itself belongs. Members may belong to multiple Gatherings and to multiple Communities.
Membership, in this sense, is not ownership, but an affiliation. To participate in a Gathering, a
Member must affiliate with a Community.

Members register with theGatherings and then affiliate with a Community, possibly preferring a
Campus.

## Identity, Access, and Authorization

Member identity is an OAuth2 token. For Members who lack or are not willing to login via a supported
OAuth2 provider (e.g., Facebook, Google), theGatherings will provide an OAuth2 provider with which the
Member must register. Either way, once registered, a Member will have an account (fed from their
OAuth provider).

Members are never deleted. They can Leave a Community and / or Gathering. When leaving, they may opt
to be Remembered. Remembered Members can re-join without an Invitation. Members who have left will
require a new Invitation (and are, for all intents and purposes, new Members).

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

Beyond the core elements of Communities, Gatherings, and Members, theGatherings will include
several other key items:

- Opportunities: Collections of service opportunities, scoped to a Community
- Resources: A loose collection of things useful to Gatherings, scoped to a theGatherings
- Tags: A free-form (that is, without a taxonomy) collection of terms used to describe Gatherings,
Opportunities, and Resources
- Discussions: Moderated dicussions associated with a Gathering, Opportunity, or Resource

## Data Management, Scale, and Deployments

Data in theGatherings divides into three core clumps: A Community and its Campuses and Gatherings,
Members, and Resources. Each is the unit of scale. All public entities will use stable, public
identifiers (such as UUIDs). This prevents having to create additional identifiers when Members
affiliate with a Community and so forth.

Data in each clump knows of data from another clump by its public, or external, identifier. Once
created public identifiers cannot change. Public identifiers are UUIDs replacing the default
primary key.

While clumps create units of scale, due to security issues, all clumps must be part of a single
Deployment. A Deployment is a logical entity. Deployments cannot share any data.

All Community, Gathering, and Member records contain, at least, two timestamps: active_on and
inactive_on.

### Dates and Times

All timestamps are stored in UTC using the Time::DATE_FORMATS[:db] format (i.e.,
"%Y-%m-%d %H:%M:%S").

Communities, Gatherings, and Members all have an associated time zone. Gatherings inherit theirs
from the owning Community (though it may be later changed). If the time zone of the Member differs
from the Community or Gathering, then dates and times displayed will include the time zone.
