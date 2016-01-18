# Architecture

## Communities, Gatherings, and Members

Gatherings builds on two core concepts: Communities and Gatherings. Gatherings always belong to one
Community. Communities have at least one Campus. Gatherings may be affiliated with a Campus. Even
though a Community must have at least one Campus, Campuses are not a top-level concept, such as
Gatherings or their owning Community, but an optional affiliation for a Gathering. A Member may
filter Gatherings to a particular Campus, but they do not seek for Gatherings through a Campus (in a
RESTful sense).

Members are not owned by Communities, Campuses, or Gatherings. But they may affiliate with each and
have designated roles within each. Members, when affiliating with a Gathering, will be automatically
affiliated with the owning Community and, if the relationship exists, Campus.

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

*TBD*

### Dates and Times

All timestamps are stored in UTC using the Time::DATE_FORMATS[:db] format (i.e.,
"%Y-%m-%d %H:%M:%S").

Communities, Gatherings, and Members all have an associated time zone. Gatherings inherit theirs
from the owning Community (though it may be later changed). If the time zone of the Member differs
from the Community or Gathering, then dates and times displayed will include the time zone.
