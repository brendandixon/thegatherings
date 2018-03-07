# Architecture

## Communities, Gatherings, and Members

Gatherings builds on three core concepts: Communities, Campuses, and Gatherings. 
A Community is a collection of Campuses; Communities have at least one Campus. Gatherings are affiliated with a Campus. A Member may filter Gatherings to a particular Campus, but they do not seek for Gatherings through a Campus (in a RESTful sense).

Members are not owned by Communities, Campuses, or Gatherings. But they may have memberships in each a with designated role.

Members register with theGatherings and then affiliate with a Community, possibly preferring a Campus.

## Identity, Access, and Authorization

Member identity is an OAuth2 token. For Members who lack or are not willing to login via a supported OAuth2 provider (e.g., Facebook, Google), theGatherings will provide an OAuth2 provider with which the Member must register. Either way, once registered, a Member will have an account (fed from their OAuth provider).

Members are never deleted. They can Leave a Community and / or Gathering. When leaving, they may opt to be Remembered. Remembered Members can re-join without an Invitation. Members who have left will require a new Invitation (and are, for all intents and purposes, new Members).

Members have access to their Communities and its Gatherings. A Member must authorize each Community.

### Authorization Model
There are five membership roles with decreasing privileges:
- Assistant
- Leader
- Overseer
- Member
- Visitor

These operate across three groups:
- Community
- Campus
- Gathering

Within each group, there are three meta-roles:
- Leaders (all Leaders and Assistants)
- Members (all Leaders, Assistants, and Members)
- Overseers (all Leaders, Assistants, and Overseers)
- Participants (all Members and Visitors)

Communities may rename all roles once per group (that is, they may define Community-level, Campus-level, and Gathering-level names).

Access rights use a CRUD model against the request group.

Lastly, Leaders may create *temporary* delegated rights (not exceeding the rights of the Overseer) to a member. Delegated rights function as short-lived memberships.

## Invitations and Joining a Gathering

Members need an Invitation to join a Gathering. Community Leaders and Gathering Overseers may send Invitations.  If the Member is already affiliated with the Community the Invitation validates their desire to to join. If they are not yet a Member, they are first asked to affiliate. After affiliating, they will be sent to the same "page" as that given to the affiliated Member (i.e., validating that they want to join).

Invitations have a lifespan (usually one week, though it may be set by the Community Leader) and are single use. *For new Members, we'll need some means of validating that the intended person is accepting the Invitation.*

## Discussions, Opportunities, Resources, and Tags

Beyond the core elements of Communities, Gatherings, and Members, theGatherings will include several other key items:

- Opportunities: Collections of service opportunities, scoped to a Community
- Resources: A loose collection of things useful to Gatherings, scoped to a theGatherings
- Tags: A free-form (that is, without a taxonomy) collection of terms used to describe Gatherings, Opportunities, and Resources
- Discussions: Moderated dicussions associated with a Gathering, Opportunity, or Resource

## Data Management, Scale, and Deployments

*TBD*

### Dates and Times

All timestamps are stored in UTC using the Time::DATE_FORMATS[:db] format (i.e.,
"%Y-%m-%d %H:%M:%S").

Communities, Gatherings, and Members all have an associated time zone. Gatherings inherit theirs from the owning Community (though it may be later changed). If the time zone of the Member differs from the Community or Gathering, then dates and times displayed will include the time zone.
